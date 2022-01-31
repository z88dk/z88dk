#include "debugger.h"
#include "backend.h"
#include "debug.h"
#include "disassembler.h"
#include "syms.h"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#include <pthread.h>
#include <sys/fcntl.h>
#include <semaphore.h>
#include "debugger_gdb_packets.h"
#include "sxmlc.h"
#include "sxmlsearch.h"

typedef void (*trapped_action_t)(const void* data, void* response);
typedef void (*network_op_cb)(void* arg);

struct network_op
{
    network_op_cb callback;
    void* arg;
    struct network_op* prev;
};

uint8_t verbose = 0;
static uint8_t registers_invalidated = 1;
static sem_t* req_response_mutex = NULL;
static sem_t* response_mutex = NULL;
static sem_t* trap_mutex = NULL;
static pthread_cond_t network_op_cond;
static pthread_mutex_t network_op_mutex;
static pthread_mutex_t trap_process_mutex;
static trapped_action_t scheduled_action = NULL;
static const void* scheduled_action_data = NULL;
static void* scheduled_action_response = NULL;
static char request_response[1024];
static uint8_t write_request = 0;
static uint8_t waiting_for_response = 0;
static const char hexchars[] = "0123456789abcdef";
static struct debugger_regs_t registers;
#define MEM_FETCH_SIZE (32)
static uint8_t mem_fetch[MEM_FETCH_SIZE] = {};
static uint16_t mem_requested_at = 0;
static uint16_t mem_requested_amount = 0;
static int connection_socket = 0;
static struct network_op* last_network_op = NULL;

enum register_mapping_t {
    REGISTER_MAPPING_AF = 0,
    REGISTER_MAPPING_BC,
    REGISTER_MAPPING_DE,
    REGISTER_MAPPING_HL,
    REGISTER_MAPPING_AF_,
    REGISTER_MAPPING_BC_,
    REGISTER_MAPPING_DE_,
    REGISTER_MAPPING_HL_,
    REGISTER_MAPPING_IX,
    REGISTER_MAPPING_IY,
    REGISTER_MAPPING_SP,
    REGISTER_MAPPING_PC,

    REGISTER_MAPPING_MAX
};

static const char* register_mapping_names[] = {
    "af",
    "bc",
    "de",
    "hl",
    "af'",
    "bc'",
    "de'",
    "hl'",
    "ix",
    "iy",
    "sp",
    "pc",
};

static enum register_mapping_t register_mappings[32] = {};
static int register_mappings_count = 0;

void post_network_op(network_op_cb calllack, void* arg)
{
    pthread_mutex_lock(&network_op_mutex);
    struct network_op* new_op = malloc(sizeof(struct network_op));
    new_op->callback = calllack;
    new_op->arg = arg;
    new_op->prev = last_network_op;
    last_network_op = new_op;
    pthread_cond_signal(&network_op_cond);
    pthread_mutex_unlock(&network_op_mutex);
}

void _write_packet_cb(void* arg)
{
    char* cp = (char*)arg;
    write_packet(cp);
    free(cp);
}

void schedule_write_packet(const char* data)
{
    char* cp = strdup(data);
    post_network_op(_write_packet_cb, (void*)cp);
}

struct scheduled_write_t
{
    uint8_t* data;
    ssize_t length;
};

void _write_raw_packet_cb(void* arg)
{
    struct scheduled_write_t* w = (struct scheduled_write_t*)arg;
    write_data_raw(w->data, w->length);
    free(w->data);
    free(w);
}

void schedule_write_raw(const uint8_t* data, ssize_t length)
{
    struct scheduled_write_t* w = malloc(sizeof(struct scheduled_write_t));
    w->data = malloc(length);
    memcpy(w->data, data, length);
    w->length = length;
    post_network_op(_write_raw_packet_cb, (void*)w);
}

static void send_request_no_response(const char* request)
{
    waiting_for_response = 0;

    schedule_write_packet(request);
}

static const char* send_request(const char* request)
{
    waiting_for_response = 1;

    schedule_write_packet(request);
    sem_wait(req_response_mutex);

    return request_response;
}

int hex(char ch)
{
    if ((ch >= 'a') && (ch <= 'f'))
        return (ch - 'a' + 10);
    if ((ch >= '0') && (ch <= '9'))
        return (ch - '0');
    if ((ch >= 'A') && (ch <= 'F'))
        return (ch - 'A' + 10);
    return (-1);
}

char *mem2hex(const uint8_t *mem, char *buf, uint32_t count)
{
    unsigned char ch;
    for (int i = 0; i < count; i++)
    {
        ch = *(mem++);
        *buf++ = hexchars[ch >> 4];
        *buf++ = hexchars[ch % 16];
    }
    *buf = 0;
    return (buf);
}

uint8_t *hex2mem(const char *buf, uint8_t *mem, uint32_t count)
{
    unsigned char ch;
    for (int i = 0; i < count; i++)
    {
        ch = hex(*buf++) << 4;
        ch = ch + hex(*buf++);
        *(mem++) = (char)ch;
    }
    return (mem);
}

static struct debugger_regs_t* fetch_registers()
{
    if (registers_invalidated)
    {
        const char* regs = send_request("g");
        if (strlen(regs) != register_mappings_count * 4)
        {
            printf("Warning: received incorrect amount of register data: %lu.\n", strlen(regs));
            return &registers;
        }

        uint16_t rr[32];
        hex2mem(regs, (void*)rr, register_mappings_count * 4);

        for (int i = 0; i < register_mappings_count; i++) {
            enum register_mapping_t reg = register_mappings[i];
            uint16_t value = rr[i];
            switch (reg)
            {
                case REGISTER_MAPPING_AF: {
                    unwrap_reg(value, &registers.a, &registers.f);
                    break;
                }
                case REGISTER_MAPPING_BC: {
                    unwrap_reg(value, &registers.b, &registers.c);
                    break;
                }
                case REGISTER_MAPPING_DE: {
                    unwrap_reg(value, &registers.d, &registers.e);
                    break;
                }
                case REGISTER_MAPPING_HL: {
                    unwrap_reg(value, &registers.h, &registers.l);
                    break;
                }
                case REGISTER_MAPPING_SP: {
#ifdef __BIG_ENDIAN__
                    registers.sp = (value>>8)|((value&0xff)<<8);
#else
                    registers.sp = value;
#endif
                    break;
                }
                case REGISTER_MAPPING_PC: {
#ifdef __BIG_ENDIAN__
                    registers.pc = (value>>8)|((value&0xff)<<8);
#else
                    registers.pc = value;
#endif
                    break;
                }
                case REGISTER_MAPPING_IX: {
                    unwrap_reg(value, &registers.xh, &registers.xl);
                    break;
                }
                case REGISTER_MAPPING_IY: {
                    unwrap_reg(value, &registers.yh, &registers.yl);
                    break;
                }
                case REGISTER_MAPPING_AF_: {
                    unwrap_reg(value, &registers.a_, &registers.f_);
                    break;
                }
                case REGISTER_MAPPING_BC_: {
                    unwrap_reg(value, &registers.b_, &registers.c_);
                    break;
                }
                case REGISTER_MAPPING_DE_: {
                    unwrap_reg(value, &registers.d_, &registers.e_);
                    break;
                }
                case REGISTER_MAPPING_HL_: {
                    unwrap_reg(value, &registers.h_, &registers.l_);
                    break;
                }
                default:
                {
                    printf("Warning: unknown mapping %d\n", reg);
                    break;
                }
            }
        }

        registers_invalidated = 0;
    }

    return &registers;
}

void invalidate()
{
    registers_invalidated = 1;
    mem_requested_amount = 0;
}

long long get_st()
{
    return 0;
}

uint16_t get_ff()
{
    return 0;
}

uint16_t get_pc()
{
    return fetch_registers()->pc;
}

uint16_t get_sp()
{
    return fetch_registers()->sp;
}

uint8_t get_memory(uint16_t at)
{
    if (at >= mem_requested_at && (int)at < (int)(mem_requested_at + mem_requested_amount))
    {
        return mem_fetch[at - mem_requested_at];
    }

    mem_requested_at = at;
    if (mem_requested_at > 4)
    {
        // request a bit early in case prior memory is needed
        mem_requested_at -= 4;
    }
    else
    {
        mem_requested_at = 0;
    }
    mem_requested_amount = MEM_FETCH_SIZE;
    if ((int)(mem_requested_at + mem_requested_amount) > 0xFFFF)
    {
        mem_requested_amount = (uint16_t)(0x10000 - (int)mem_requested_at);
    }

    if (verbose)
    {
        printf("Fetching a chunk of %d bytes starting from address %d.\n", mem_requested_amount, mem_requested_at);
    }

    char req[64];
    sprintf(req, "m%zx,%zx", (size_t)mem_requested_at, (size_t)mem_requested_amount);

    const char* mem = send_request(req);
    uint32_t bytes_recv = strlen(mem) / 2;
    if (bytes_recv != mem_requested_amount)
    {
        printf("Warning: received incorrect amount of data.");
        return 0;
    }

    hex2mem(mem, (void*)mem_fetch, bytes_recv);

    return mem_fetch[at - mem_requested_at];
}

void get_regs(struct debugger_regs_t* regs)
{
    memcpy(regs, fetch_registers(), sizeof(struct debugger_regs_t));
}

void set_regs(struct debugger_regs_t* regs)
{
    memcpy(&registers, regs, sizeof(struct debugger_regs_t));


    uint16_t rr[32] = {};

    for (int i = 0; i < register_mappings_count; i++) {
        enum register_mapping_t reg = register_mappings[i];
        uint16_t value;
        switch (reg)
        {
            case REGISTER_MAPPING_AF: {
                value = wrap_reg(regs->a, regs->f);
                break;
            }
            case REGISTER_MAPPING_BC: {
                value = wrap_reg(regs->b, regs->c);
                break;
            }
            case REGISTER_MAPPING_DE: {
                value = wrap_reg(regs->d, regs->e);
                break;
            }
            case REGISTER_MAPPING_HL: {
                value = wrap_reg(regs->h, regs->l);
                break;
            }
            case REGISTER_MAPPING_SP: {
#ifdef __BIG_ENDIAN__
                value = (registers.sp>>8)|((registers.sp&0xff)<<8);
#else
                value = registers.sp;
#endif
                break;
            }
            case REGISTER_MAPPING_PC: {
#ifdef __BIG_ENDIAN__
                value = (registers.pc>>8)|((registers.pc&0xff)<<8);
#else
                value = registers.pc;
#endif
                break;
            }
            case REGISTER_MAPPING_IX: {
                value = wrap_reg(regs->xh, regs->xl);
                break;
            }
            case REGISTER_MAPPING_IY: {
                value = wrap_reg(regs->yh, regs->yl);
                break;
            }
            case REGISTER_MAPPING_AF_: {
                value = wrap_reg(regs->a_, regs->f_);
                break;
            }
            case REGISTER_MAPPING_BC_: {
                value = wrap_reg(regs->b_, regs->c_);
                break;
            }
            case REGISTER_MAPPING_DE_: {
                value = wrap_reg(regs->d_, regs->e_);
                break;
            }
            case REGISTER_MAPPING_HL_: {
                value = wrap_reg(regs->h_, regs->l_);
                break;
            }
            default:
            {
                continue;
            }
        }
        rr[i] = value;
    }

    char req[128] = {0};
    req[0] = 'G';
    mem2hex((void*)rr, &req[1], register_mappings_count * 2);

    const char* resp = send_request(req);

    if (strcmp(resp, "OK") != 0)
    {
        printf("Warning: could not set the registers: %s\n", resp);
    }
    else
    {
        registers_invalidated = 1;
        fetch_registers();
    }
}

int f()
{
    return fetch_registers()->f;
}

int f_()
{
    return fetch_registers()->f_;
}

void memory_reset_paging() {}
void port_out(int port, int value) {}
void debugger_write_memory(int addr, uint8_t val) {}
void debugger_read_memory(int addr) {}

void debugger_break()
{
    static uint8_t req[] = { 0x03 };
    schedule_write_raw(req, 1);
}

void debugger_detach()
{
    send_request("D");
    shutdown(connection_socket, 0);
}

void debugger_resume()
{
    debugger_active = 0;
    send_request_no_response("c");
}

void add_breakpoint(uint8_t type, uint16_t at, uint8_t sz)
{
    switch (type)
    {
        case BK_BREAKPOINT_REGISTER:
        case BK_BREAKPOINT_HARDWARE:
        {
            printf("Warning: not supported.\n");
            return;
        }
    }

    char req[64];
    sprintf(req, "Z%zx,%zx,%zx", (size_t)type, (size_t)at, (size_t)sz);
    const char* resp = send_request(req);
    if (strcmp(resp, "E01") == 0)
    {
        printf("Could not set breakpoint.\n");
    }
    else if (strcmp(resp, "OK") != 0)
    {
        printf("Could not set breakpoint: %s\n", resp);
    }
}

void remove_breakpoint(uint8_t type, uint16_t at, uint8_t sz)
{
    char req[64];
    sprintf(req, "z%zx,%zx,%zx", (size_t)type, (size_t)at, (size_t)sz);
    const char* resp = send_request(req);
    if (strcmp(resp, "E01") == 0)
    {
        printf("Could not set breakpoint.\n");
    }
    else if (strcmp(resp, "OK") != 0)
    {
        printf("Could not set breakpoint: %s\n", resp);
    }
}

void disable_breakpoint(uint8_t type, uint16_t at, uint8_t sz)
{
    printf("Warning: not supported.\n");
}

void enable_breakpoint(uint8_t type, uint16_t at, uint8_t sz)
{
    printf("Warning: not supported.\n");
}

uint8_t breakpoints_check()
{
    return 1;
}

void debugger_next()
{
    char  buf[100];
    int len = disassemble2(bk.pc(), buf, sizeof(buf), 0);

    char req[64];
    sprintf(req, "i%d", len);
    schedule_write_packet(req);
    debugger_active = 0;
}

void debugger_step()
{
    schedule_write_packet("s");
    debugger_active = 0;
}

uint8_t debugger_restore(const char* file_path, uint16_t at)
{
    FILE *f = fopen(file_path, "rb");
    if (f == NULL)
    {
        printf("Could not open file.\n");
        return 1;
    }

    size_t addr = at;

    uint8_t buff[256];
    size_t read_;
    while ((read_ = fread(buff, 1, 256, f)))
    {
        char s[1024];
        int offset;
        sprintf(s, "M%zx,%zx:%n", addr, read_, &offset);
        mem2hex(buff, &s[offset], read_);
        const char* response = send_request(s);
        if (strcmp(response, "OK") != 0)
        {
            printf("Warning: Cannot restore file at addr %zx: %s\n", addr, response);
            return 1;
        }

        addr += read_;
    }

    fclose(f);

    mem_requested_amount = 0;

    // zero out all registers except for pc
    struct debugger_regs_t regs;
    bk.get_regs(&regs);
    int sp = regs.sp;
    memset(&regs, 0, sizeof(regs));
    regs.pc = at;
    regs.sp = sp;
    set_regs(&regs);
    return 0;
}

static backend_t gdb_backend = {
    .st = &get_st,
    .ff = &get_ff,
    .pc = &get_pc,
    .sp = &get_sp,
    .get_memory = &get_memory,
    .get_regs = &get_regs,
    .set_regs = &set_regs,
    .f = &f,
    .f_ = &f_,
    .memory_reset_paging = &memory_reset_paging,
    .out = &port_out,
    .debugger_write_memory = &debugger_write_memory,
    .debugger_read_memory = &debugger_read_memory,
    .invalidate = &invalidate,
    .breakable = 1,
    .break_ = &debugger_break,
    .resume = &debugger_resume,
    .next = &debugger_next,
    .step = &debugger_step,
    .confirm_detach_w_breakpoints = 1,
    .detach = &debugger_detach,
    .restore = &debugger_restore,
    .add_breakpoint = &add_breakpoint,
    .remove_breakpoint = &remove_breakpoint,
    .disable_breakpoint = &disable_breakpoint,
    .enable_breakpoint = &enable_breakpoint,
    .breakpoints_check = &breakpoints_check
};

static void execute_on_main_thread(trapped_action_t call, const void* data, void* response)
{
    // prepare the action arguments
    pthread_mutex_lock(&trap_process_mutex);
    scheduled_action = call;
    scheduled_action_data = data;
    scheduled_action_response = response;
    pthread_mutex_unlock(&trap_process_mutex);

    // notify the main thread
    sem_post(trap_mutex);

    // wait for the response
    sem_wait(response_mutex);
}

static void execute_on_main_thread_no_response(trapped_action_t call, const void* data)
{
    // prepare the action arguments
    pthread_mutex_lock(&trap_process_mutex);
    scheduled_action = call;
    scheduled_action_data = data;
    scheduled_action_response = NULL;
    pthread_mutex_unlock(&trap_process_mutex);

    // notify the main thread
    sem_post(trap_mutex);
}

void remote_execution_stopped(const void* data, void* response)
{
    if (debugger_active == 1)
    {
        return;
    }

    if (verbose)
    {
        printf("Execution stopped.\n");
    }

    debugger_active = 1;
}

static uint8_t process_packet()
{
    uint8_t *inbuf = inbuf_get();
    int inbuf_size = inbuf_end();

    if (inbuf_size == 0) {
        return 0;
    }

    if (inbuf_size > 0 && *inbuf == '+') {
        if (verbose) {
            printf("ack.\n");
        }
        inbuf_erase_head(1);
        return 1;
    }

    if (verbose) {
        printf("r: %.*s\n", inbuf_size, inbuf);
    }

    uint8_t *packetend_ptr = (uint8_t *)memchr(inbuf, '#', inbuf_size);
    if (packetend_ptr == NULL) {
        return 0;
    }

    int packetend = packetend_ptr - inbuf;
    inbuf[packetend] = '\0';

    uint8_t checksum = 0;
    int i;
    for (i = 1; i < packetend; i++)
        checksum += inbuf[i];

    if (checksum != (hex(inbuf[packetend + 1]) << 4 | hex(inbuf[packetend + 2])))
    {
        inbuf_erase_head(packetend + 3);
        return 1;
    }

    char recv_data[1024];
    strcpy(recv_data, (char*)&inbuf[1]);
    inbuf_erase_head(packetend + 3);

    if (waiting_for_response)
    {
        waiting_for_response = 0;
        strcpy(request_response, recv_data);
        sem_post(req_response_mutex);
    }
    else
    {
        char request = recv_data[0];
        char *payload = (char *)&recv_data[1];

        switch (request)
        {
            case 'T':
            {
                execute_on_main_thread_no_response(&remote_execution_stopped, NULL);

                break;
            }
        }
    }

    return 1;
}

static void* network_read_thread(void* arg)
{
    sock_t socket = *(sock_t*)arg;

    while (1)
    {
        int ret;
        if ((ret = read_packet(socket)))
        {
            printf("A network error occured: %d\n", ret);
            break;
        }

        while (process_packet()) {};
    }

    shutdown(socket, 0);
    printf("Disconnected.\n");
    exit(1);

    return NULL;
}

static void* network_write_thread(void* arg)
{
    sock_t socket = *(sock_t*)arg;

    while (1)
    {
        pthread_mutex_lock(&network_op_mutex);
        while (last_network_op == NULL) {
            pthread_cond_wait(&network_op_cond, &network_op_mutex);
        }
        // execute network operations from main thread
        while (last_network_op) {
            struct network_op* prev = last_network_op->prev;
            last_network_op->callback(last_network_op->arg);
            free(last_network_op);
            last_network_op = prev;
        }
        write_flush(socket);
        pthread_mutex_unlock(&network_op_mutex);
    }

    return NULL;
}


int main(int argc, char **argv) {
    char* connect_host = NULL;
    int connect_port = 0;

    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "-p") == 0) {
            connect_port = atoi(argv[++i]);
        } else if (strcmp(argv[i], "-h") == 0) {
            connect_host = argv[++i];
        } else if (strcmp(argv[i], "-x") == 0) {
            char* debug_symbols = argv[++i];
            printf("Reading debug symbols...");
            read_symbol_file(debug_symbols);
            printf("OK\n");
        } else if (strcmp(argv[i], "-v") == 0) {
            verbose = 1;
        }
    }

    if (connect_port == 0 || connect_host == NULL) {
        printf("z88dk-gdb, a gdb client.\n");
        printf("Usage: z88dk-gdb -h <connect host> -p <connect port> -x <debug symbols> [-x <debug symbols>] [-v]\n");
        return 1;
    }

    debugger_init();
    set_backend(gdb_backend);

    connection_socket = socket(AF_INET, SOCK_STREAM, 0);

    struct sockaddr_in servaddr;
    memset(&servaddr, 0, sizeof(servaddr));

    // assign IP, PORT
    servaddr.sin_family = AF_INET;
    servaddr.sin_addr.s_addr = inet_addr(connect_host);
    servaddr.sin_port = htons(connect_port);

    // connect the client socket to server socket
    int ret = connect(connection_socket, (struct sockaddr*)&servaddr, sizeof(servaddr));
    if (ret) {
        printf("Could not connect to the server: %d\n", ret);
        return 1;
    } else {
        printf("Connected to the server.\n");
    }

    sem_unlink("req_response_mutex");
    req_response_mutex = sem_open("req_response_mutex", O_CREAT|O_EXCL, 0600, 0);
    sem_unlink("response_mutex");
    response_mutex = sem_open("response_mutex", O_CREAT|O_EXCL, 0600, 0);
    sem_unlink("trap_mutex");
    trap_mutex = sem_open("trap_mutex", O_CREAT|O_EXCL, 0600, 0);

    pthread_cond_init(&network_op_cond, NULL);
    pthread_mutex_init(&network_op_mutex, NULL);
    pthread_mutex_init(&trap_process_mutex, NULL);

    {
        pthread_t id;
        pthread_create(&id, NULL, network_read_thread, &connection_socket);
        pthread_detach(id);
    }

    {
        pthread_t id;
        pthread_create(&id, NULL, network_write_thread, &connection_socket);
        pthread_detach(id);
    }

    {
        const char* supported = send_request("qSupported");
        if (supported == NULL || strstr(supported, "qXfer:features:read+") == NULL)
        {
            printf("Remote target does not support qXfer:features:read+\n");
            goto shutdown;
        }

        if (strstr(supported, "NonBreakable")) {
            printf("Warning: remote is not breakable; cannot request execution to stop from here\n");
            bk.breakable = 0;
        }
    }

    {
        const char* target = send_request("qXfer:features:read:target.xml:0,3fff");
        if (target == NULL || *target++ != 'l') {
            printf("Could not obtain target.xml\n");
            goto shutdown;
        }

        XMLDoc xml;
        XMLDoc_init(&xml);

        if (XMLDoc_parse_buffer_DOM(target, "features", &xml) == 0) {
            printf("Cannot parse target.xml.\n");
            XMLDoc_free(&xml);
            goto shutdown;
        }

        {
            XMLSearch search;
            XMLSearch_init_from_XPath("target/architecture", &search);
            XMLNode* arch = xml.nodes[xml.i_root];
            if ((arch = XMLSearch_next(arch, &search)) == NULL) {
                printf("Unknown architecture.\n");
                goto shutdown;
            }

            if (strcmp(arch->text, "z80") != 0) {
                printf("Unsupported architecture: %s\n", arch->text);
                goto shutdown;
            }
            XMLSearch_free(&search, 1);
        }

        {
            XMLSearch search;
            XMLSearch_init_from_XPath("target/feature[@name='*z80*']/reg", &search);
            XMLNode* reg = xml.nodes[xml.i_root];
            while ((reg = XMLSearch_next(reg, &search)))
            {
                const char* reg_name;
                if (XMLNode_get_attribute(reg, "name", &reg_name) == 0) {
                    continue;
                }

                for (int i = 0; i < REGISTER_MAPPING_MAX; i++) {
                    if (strcmp(reg_name, register_mapping_names[i]) == 0) {
                        register_mappings[register_mappings_count++] = i;
                        break;
                    }
                }
            }

            XMLSearch_free(&search, 1);
        }

        XMLDoc_free(&xml);

        uint8_t got_ix = 0;
        uint8_t got_sp = 0;
        uint8_t got_pc = 0;
        if (verbose) {
            printf("Registers: ");
        }
        for (int i = 0; i < register_mappings_count; i++) {
            if (verbose) {
                printf(" %s", register_mapping_names[register_mappings[i]]);
            }
            if (register_mappings[i] == REGISTER_MAPPING_IX) {
                got_ix = 1;
                continue;
            }
            if (register_mappings[i] == REGISTER_MAPPING_SP) {
                got_sp = 1;
                continue;
            }
            if (register_mappings[i] == REGISTER_MAPPING_PC) {
                got_pc = 1;
                continue;
            }
        }
        if (verbose) {
            printf("\n");
        }
        if (got_ix == 0 || got_pc == 0 || got_sp == 0) {
            printf("Insufficient register information.\n");
        }
    }

    // this should break us
    send_request_no_response("?");

    while (1)
    {
        registers_invalidated = 1;

        debugger_process_signals();

        if (debugger_active)
        {
            debugger();
        }
        else
        {
            sem_wait(trap_mutex);

            pthread_mutex_lock(&trap_process_mutex);
            if (scheduled_action != NULL)
            {
                scheduled_action(scheduled_action_data, scheduled_action_response);
                scheduled_action = NULL;

                if (scheduled_action_response != NULL)
                {
                    // notify the waiter that we're done
                    sem_post(response_mutex);
                }
            }
            pthread_mutex_unlock(&trap_process_mutex);
        }
    }

shutdown:
    shutdown(connection_socket, 0);

    return 0;
}
