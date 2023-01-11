#include "debugger_gdb.h"
#include "debugger.h"
#include "debugger_mi2.h"
#include "backend.h"
#include "debug.h"
#include "disassembler.h"
#include "syms.h"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <sys/time.h>

#include <pthread.h>
#include <utstring.h>
#include "debugger_gdb_packets.h"
#include "sxmlc.h"
#include "sxmlsearch.h"

#ifdef WIN32
#include <windows.h>
#else
#include <unistd.h>
#endif

#define SEC_TO_US(sec) ((sec)*1000000)
#define NS_TO_US(ns)    ((ns)/1000)

static uint8_t verbose = 0;
int c_autolabel = 0;
uint8_t temporary_break = 0;
static uint8_t has_clock_register = 0;
static uint8_t registers_invalidated = 1;
static pthread_cond_t network_op_cond;
static pthread_mutex_t network_op_mutex;

static pthread_cond_t main_thread_cond;
static pthread_mutex_t main_thread_mutex;
static int supported_packet_size = 1024;

struct scheduled_action_t
{
    trapped_action_t scheduled_action;
    const void* scheduled_action_data;
    void* scheduled_action_response;
    uint8_t* wait;

    pthread_mutex_t* wait_mutex;
    pthread_cond_t* wait_cond;

    struct scheduled_action_t* next;
};

static struct scheduled_action_t* first_scheduled_action = NULL;
static char request_response[1024];
static uint8_t write_request = 0;
static pthread_mutex_t req_response_mutex;
static pthread_cond_t req_response_cond;
static uint8_t waiting_for_response = 0;
static const char hexchars[] = "0123456789abcdef";
static struct debugger_regs_t registers;
#define MEM_FETCH_SIZE (32)
static uint8_t mem_fetch[MEM_FETCH_SIZE] = {0};
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

    /*
     * Some emulators would report this 16bit register pair, which could be used
     * to track ticks for profiling purposes
     */
    REGISTER_MAPPING_CLOCKL,
    REGISTER_MAPPING_CLOCKH,

    REGISTER_MAPPING_MAX,
    REGISTER_MAPPING_UNKNOWN
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

    /*
     * Some emulators would report this 16bit register pair, which could be used
     * to track ticks for profiling purposes
     */
    "clockl_",
    "clockh_",
};

static enum register_mapping_t register_mappings[32] = {0};
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
    schedule_write_packet(request);
}

static const char* send_request(const char* request)
{
    pthread_mutex_lock(&req_response_mutex);
    waiting_for_response = 1;
    schedule_write_packet(request);

    while (waiting_for_response) {
        pthread_cond_wait(&req_response_cond, &req_response_mutex);
    }
    pthread_mutex_unlock(&req_response_mutex);

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
            bk.debug("Warning: received incorrect amount of register data: %lu.\n", strlen(regs));
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
                case REGISTER_MAPPING_CLOCKL: {
#ifdef __BIG_ENDIAN__
                    registers.clockl = (value>>8)|((value&0xff)<<8);
#else
                    registers.clockl = value;
#endif
                    break;
                }
                case REGISTER_MAPPING_CLOCKH: {
#ifdef __BIG_ENDIAN__
                    registers.clockh = (value>>8)|((value&0xff)<<8);
#else
                    registers.clockh = value;
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
                case REGISTER_MAPPING_UNKNOWN:
                default: {
                    // we don't support such register, so we chose to ignore it
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

uint8_t is_verbose()
{
    return verbose;
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

    if (bk.is_verbose())
    {
        bk.debug("Fetching a chunk of %d bytes starting from address %d.\n", mem_requested_amount, mem_requested_at);
    }

    char req[64];
    sprintf(req, "m%zx,%zx", (size_t)mem_requested_at, (size_t)mem_requested_amount);

    const char* mem = send_request(req);
    uint32_t bytes_recv = strlen(mem) / 2;
    if (bytes_recv != mem_requested_amount)
    {
        bk.debug("Warning: received incorrect amount of data.");
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


    uint16_t rr[32] = {0};

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
            case REGISTER_MAPPING_UNKNOWN:
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
        bk.debug("Warning: could not set the registers: %s\n", resp);
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

void debugger_gdb_break(uint8_t temporary)
{
    if (temporary)
    {
        temporary_break = 1;
    }

    if (connection_socket == 0)
    {
        bk.debug("Nothing to break, as we're not connected.\n");
        return;
    }

    static uint8_t req[] = { 0x03 };
    schedule_write_raw(req, 1);
}

void debugger_detach()
{
    send_request("D");
    shutdown(connection_socket, 0);
    connection_socket = 0;
}

void debugger_resume()
{
    debugger_active = 0;
    send_request_no_response("c");
}

breakpoint_ret_t gdb_add_breakpoint(uint8_t type, uint16_t at, uint8_t sz)
{
    if (connection_socket == 0) {
        return BREAKPOINT_ERROR_NOT_CONNECTED;
    }

    if (debugger_active == 0) {
        return BREAKPOINT_ERROR_RUNNING;
    }

    switch (type) {
        case BK_BREAKPOINT_REGISTER:
        case BK_BREAKPOINT_HARDWARE:
        {
            return BREAKPOINT_ERROR_FAILURE;
        }
    }

    char req[64];
    sprintf(req, "Z%zx,%zx,%zx", (size_t)type, (size_t)at, (size_t)sz);
    const char* resp = send_request(req);
    if (strcmp(resp, "OK") != 0)
    {
        return BREAKPOINT_ERROR_FAILURE;
    }

    return BREAKPOINT_ERROR_OK;
}

breakpoint_ret_t gdb_remove_breakpoint(uint8_t type, uint16_t at, uint8_t sz)
{
    if (connection_socket == 0) {
        return BREAKPOINT_ERROR_NOT_CONNECTED;
    }
    if (debugger_active == 0) {
        return BREAKPOINT_ERROR_RUNNING;
    }

    char req[64];
    sprintf(req, "z%zx,%zx,%zx", (size_t)type, (size_t)at, (size_t)sz);
    const char* resp = send_request(req);
    if (strcmp(resp, "OK") != 0)
    {
        return BREAKPOINT_ERROR_FAILURE;
    }

    return BREAKPOINT_ERROR_OK;
}

breakpoint_ret_t gdb_disable_breakpoint(uint8_t type, uint16_t at, uint8_t sz)
{
    return BREAKPOINT_ERROR_FAILURE;
}

breakpoint_ret_t gdb_enable_breakpoint(uint8_t type, uint16_t at, uint8_t sz)
{
    return BREAKPOINT_ERROR_FAILURE;
}

uint8_t breakpoints_check()
{
    return 1;
}

void debugger_next(uint8_t add_bp)
{
    static char buf[2048];
    int len;
    const unsigned short pc = bk.pc();

    uint8_t opcode = bk.get_memory(pc);

    len = disassemble2(pc, buf, sizeof(buf), 0);

    // Set a breakpoint after the call
    switch ( opcode ) {
        case 0xed: // ED prefix
        case 0xcb: // CB prefix
        case 0xc4:
        case 0xcc:
        case 0xcd:
        case 0xd4:
        case 0xdc:
        case 0xe4:
        case 0xec:
        case 0xf4:
        {
            // It's a call, so step it over
            char req[64];
            sprintf(req, "i%d", len);
            schedule_write_packet(req);
            if (add_bp) {
                add_temp_breakpoint_one_instruction();
            }
            debugger_active = 0;
            return;
        }
    }

    // it's something else, so do a regular step
    schedule_write_packet("s");
    if (add_bp) {
        add_temp_breakpoint_one_instruction();
    }
    debugger_active = 0;
}

void debugger_step(uint8_t add_bp)
{
    if (add_bp) {
        add_temp_breakpoint_one_instruction();
    }
    schedule_write_packet("s");
    debugger_active = 0;
}

uint8_t debugger_restore(const char* file_path, uint16_t at, uint8_t set_pc)
{
    bk.debug("Uploading binary %s\n", file_path);

    FILE *f = fopen(file_path, "rb");
    if (f == NULL)
    {
        bk.debug("Could not open file.\n");
        return 1;
    }

    size_t addr = at;
    size_t post_at_once = (supported_packet_size - 16) / 2;

    uint8_t* buff = malloc(post_at_once);
    char* hex_buff = malloc(post_at_once * 2 + 1);
    size_t read_;
    while ((read_ = fread(buff, 1, post_at_once, f)))
    {
        UT_string s;
        utstring_init(&s);
        utstring_printf(&s, "M%zx,%zx:", addr, read_);
        mem2hex(buff, hex_buff, read_);
        utstring_bincpy(&s, hex_buff, read_ * 2);
        const char* response = send_request(utstring_body(&s));
        if (strcmp(response, "OK") != 0)
        {
            bk.debug("Warning: Cannot restore file at addr %zx: %s\n", addr, response);

            free(buff);
            free(hex_buff);
            fclose(f);

            utstring_done(&s);
            return 1;
        }

        addr += read_;
        utstring_done(&s);
    }

    free(buff);
    free(hex_buff);
    fclose(f);

    mem_requested_amount = 0;

    bk.debug("Uploading binary %s complete\n", file_path);

    if (set_pc) {
        // zero out all registers except for pc
        struct debugger_regs_t regs;
        bk.get_regs(&regs);
        int sp = regs.sp;
        memset(&regs, 0, sizeof(regs));
        regs.pc = at;
        regs.sp = sp;
        set_regs(&regs);

        bk.debug("Replaced register PC=%04x\n", at);
    }
    return 0;
}

void execute_on_main_thread(trapped_action_t call, const void* data, void* response)
{
    pthread_mutex_t wait_mutex;
    pthread_cond_t wait_cond;

    pthread_mutex_init(&wait_mutex, NULL);
    pthread_cond_init(&wait_cond, NULL);

    uint8_t wait = 1;

    // prepare the action arguments
    pthread_mutex_lock(&main_thread_mutex);
    struct scheduled_action_t* aa = calloc(1, sizeof(struct scheduled_action_t));
    aa->scheduled_action = call;
    aa->scheduled_action_data = data;
    aa->scheduled_action_response = response;
    aa->wait = &wait;
    aa->wait_mutex = &wait_mutex;
    aa->wait_cond = &wait_cond;
    LL_APPEND(first_scheduled_action, aa);

    // notify the main thread
    pthread_cond_signal(&main_thread_cond);
    pthread_mutex_unlock(&main_thread_mutex);

    pthread_mutex_lock(&wait_mutex);

    // wait for the response on the same cond
    while (wait)
    {
        pthread_cond_wait(&wait_cond, &wait_mutex);
    }

    pthread_mutex_unlock(&wait_mutex);

    pthread_mutex_destroy(&wait_mutex);
    pthread_cond_destroy(&wait_cond);
}

void execute_on_main_thread_no_response(trapped_action_t call, const void* data)
{
    // prepare the action arguments
    pthread_mutex_lock(&main_thread_mutex);
    struct scheduled_action_t* aa = calloc(1, sizeof(struct scheduled_action_t));
    aa->scheduled_action = call;
    aa->scheduled_action_data = data;
    aa->scheduled_action_response = NULL;
    aa->wait = NULL;
    LL_APPEND(first_scheduled_action, aa);

    // notify the main thread
    pthread_cond_signal(&main_thread_cond);

    pthread_mutex_unlock(&main_thread_mutex);
}

static void gdb_execution_stopped()
{
    if (debugger_active == 1)
    {
        return;
    }

    if (bk.is_verbose())
    {
        bk.debug("Execution stopped\n");
    }

    debugger_active = 1;
}

void remote_execution_stopped(const void* data, void* response)
{
    bk.execution_stopped();
}

static uint8_t process_packet()
{
    uint8_t *inbuf = inbuf_get();
    int inbuf_size = inbuf_end();

    if (inbuf_size == 0) {
        return 0;
    }

    if (inbuf_size > 0 && *inbuf == '+') {
        if (bk.is_verbose()) {
            bk.debug("ack.\n");
        }
        inbuf_erase_head(1);
        return 1;
    }

    if (bk.is_verbose()) {
        bk.debug("r: %.*s\n", inbuf_size, inbuf);
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
        if (bk.is_verbose()) {
            bk.debug("Warning: incorrect checksum, expected: %02x\n", checksum);
        }
        inbuf_erase_head(packetend + 3);
        return 1;
    }

    char recv_data[1024];
    strcpy(recv_data, (char*)&inbuf[1]);
    inbuf_erase_head(packetend + 3);

    pthread_mutex_lock(&req_response_mutex);

    if (waiting_for_response)
    {
        waiting_for_response = 0;
        strcpy(request_response, recv_data);
        pthread_cond_signal(&req_response_cond);
        pthread_mutex_unlock(&req_response_mutex);
        return 1;
    }

    pthread_mutex_unlock(&req_response_mutex);

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

    return 1;
}

static void* network_read_thread(void* arg)
{
    sock_t socket = *(sock_t*)arg;

    while (connection_socket)
    {
        int ret;
        if ((ret = read_packet(socket)))
        {
            break;
        }

        while (process_packet()) {};
    }

    return NULL;
}

static void* network_write_thread(void* arg)
{
    sock_t socket = *(sock_t*)arg;

    while (connection_socket)
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

static void init_mutexes()
{
    pthread_mutex_init(&main_thread_mutex, NULL);
    pthread_cond_init(&main_thread_cond, NULL);

    pthread_mutex_init(&req_response_mutex, NULL);
    pthread_cond_init(&req_response_cond, NULL);

    pthread_mutex_init(&network_op_mutex, NULL);
    pthread_cond_init(&network_op_cond, NULL);
}

static uint8_t is_gdbserver_connected()
{
    return connection_socket;
}

static uint8_t connect_to_gdbserver(const char* connect_host, int connect_port)
{
    connection_socket = socket(AF_INET, SOCK_STREAM, 0);
#ifdef _WIN32
	if (connection_socket == SOCKET_ERROR) {
		bk.debug("Socket error: %d\n", WSAGetLastError());
		return 1;
	}
#endif

    struct sockaddr_in servaddr;
    memset(&servaddr, 0, sizeof(servaddr));

    // assign IP, PORT
    servaddr.sin_family = AF_INET;
    servaddr.sin_addr.s_addr = inet_addr(connect_host);
    servaddr.sin_port = htons(connect_port);

    // connect the client socket to server socket
    int ret = connect(connection_socket, (struct sockaddr*)&servaddr, sizeof(servaddr));
    if (ret) {
        return 1;
    }

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
            bk.debug("Remote target does not support qXfer:features:read+\n");
            goto shutdown;
        }

        if (strstr(supported, "NonBreakable")) {
            bk.debug("Warning: remote is not breakable; cannot request execution to stop from here\n");
            bk.breakable = 0;
        }

        int pkt_size;
        const char* pkt_size_str = strstr(supported, "PacketSize");
        if (pkt_size_str == NULL) {
            bk.debug("Warning: cannot sync packet size, assuming %d\n", supported_packet_size);
        } else {
            if (sscanf(pkt_size_str, "PacketSize=%d", &pkt_size) != 1) {
                bk.debug("Warning: cannot sync packet size, assuming %d\n", supported_packet_size);
            } else {
                supported_packet_size = pkt_size;
                if (verbose) {
                    bk.debug("Synced on packet size: %d\n", supported_packet_size);
                }
            }
        }
    }

    {
        const char* target = send_request("qXfer:features:read:target.xml:0,3fff");
        if (target == NULL || *target++ != 'l') {
            bk.debug("Could not obtain target.xml\n");
            goto shutdown;
        }

        XMLDoc xml;
        XMLDoc_init(&xml);

        if (XMLDoc_parse_buffer_DOM(target, "features", &xml) == 0) {
            bk.debug("Cannot parse target.xml.\n");
            XMLDoc_free(&xml);
            goto shutdown;
        }

        {
            XMLSearch search;
            XMLSearch_init_from_XPath("target/architecture", &search);
            XMLNode* arch = xml.nodes[xml.i_root];
            if ((arch = XMLSearch_next(arch, &search)) == NULL) {
                bk.debug("Unknown architecture.\n");
                goto shutdown;
            }

            if (strcmp(arch->text, "z80") != 0) {
                bk.debug("Unsupported architecture: %s\n", arch->text);
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

                uint8_t found_mapping = 0;

                for (int i = 0; i < REGISTER_MAPPING_MAX; i++) {
                    if (strcmp(reg_name, register_mapping_names[i]) == 0) {
                        register_mappings[register_mappings_count++] = i;
                        found_mapping = 1;
                        break;
                    }
                }

                if (found_mapping == 0) {
                    register_mappings[register_mappings_count++] = REGISTER_MAPPING_UNKNOWN;
                }
            }

            XMLSearch_free(&search, 1);
        }

        XMLDoc_free(&xml);

        uint8_t got_sp = 0;
        uint8_t got_pc = 0;
        if (verbose) {
            bk.debug("Registers: ");
        }
        for (int i = 0; i < register_mappings_count; i++) {
            if (verbose) {
                bk.debug(" %s", register_mapping_names[register_mappings[i]]);
            }
            if (register_mappings[i] == REGISTER_MAPPING_SP) {
                got_sp = 1;
                continue;
            }
            if (register_mappings[i] == REGISTER_MAPPING_PC) {
                got_pc = 1;
                continue;
            }
            if (register_mappings[i] == REGISTER_MAPPING_CLOCKL) {
                has_clock_register = 1;
                continue;
            }
        }
        if (verbose) {
            bk.debug("\n");
        }
        if (got_pc == 0 || got_sp == 0) {
            bk.debug("Insufficient register information.\n");
        }
        if (has_clock_register) {
            if (verbose) {
                bk.debug("Remote has 'clock' register.\n");
            }
        }
    }

    // this should break us
    send_request_no_response("?");

    return 0;

shutdown:
    shutdown(connection_socket, 0);
    return 1;
}

static void ctrl_c_main_thread(const void* data, void* response) {
    debugger_request_a_break();
}

static volatile uint8_t ctrl_c_requested = 0;

/*
 * The purpose of this crude loop is to offload signal handling to main thread,
 * as it is not safe to do most of the stuff in a signal handler directly.
 */
static void* ctrl_c_signal_loop(void* arg) {
    while (1) {
        if (ctrl_c_requested) {
            ctrl_c_requested = 0;
            execute_on_main_thread_no_response(ctrl_c_main_thread, NULL);
        }
#ifdef WIN32
        Sleep(100);
#else
        usleep(100000);
#endif
    }
    return NULL;
}

static void start_ctrl_c_signal_loop() {
    static pthread_t ctrl_c_thread;
    pthread_create(&ctrl_c_thread, NULL, ctrl_c_signal_loop, NULL);
}

static void ctrl_c() {
    ctrl_c_requested = 1;
}

uint32_t gdb_profiler_time() {
    if (has_clock_register) {
        /*
         * Some emulators would report this 16bit register pair, which could be used
         * to track ticks for profiling purposes
         */
        struct debugger_regs_t regs;
        bk.get_regs(&regs);
        return ((uint32_t)regs.clockh << 16) + regs.clockl;
    }

#ifdef WIN32
    // limit ourselfs to few milliseconds on windows
    return GetTickCount();
#else
    // Otherwise, get a time stamp in microseconds. Inaccurate but beats nothing.
    struct timeval tv;

    gettimeofday(&tv, NULL);
    uint64_t us = SEC_TO_US((uint64_t)tv.tv_sec) + tv.tv_usec;
    return (uint32_t)us;
#endif
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
    .break_ = &debugger_gdb_break,
    .resume = &debugger_resume,
    .next = &debugger_next,
    .step = &debugger_step,
    .confirm_detach_w_breakpoints = 1,
    .detach = &debugger_detach,
    .restore = &debugger_restore,
    .add_breakpoint = &gdb_add_breakpoint,
    .remove_breakpoint = &gdb_remove_breakpoint,
    .disable_breakpoint = &gdb_disable_breakpoint,
    .enable_breakpoint = &gdb_enable_breakpoint,
    .breakpoints_check = &breakpoints_check,
    .is_verbose = is_verbose,
    .remote_connect = connect_to_gdbserver,
    .is_remote_connected = is_gdbserver_connected,
    .console = stdout_log,
    .debug = stdout_log,
    .execution_stopped = gdb_execution_stopped,
    .ctrl_c = ctrl_c,
    .time = gdb_profiler_time
};

static void process_scheduled_actions()
{
    pthread_mutex_lock(&main_thread_mutex);

    // wait until we have a job
    while (first_scheduled_action == NULL)
    {
        pthread_cond_wait(&main_thread_cond, &main_thread_mutex);
    }

    // we need to unblock the queue for new jobs. jobs scheduled on main thread may want to
    // schedule new jobs. to mitigate that deadlock, the queue is blocked on its own
    struct scheduled_action_t* first_to_process = first_scheduled_action;
    first_scheduled_action = NULL;

    pthread_mutex_unlock(&main_thread_mutex);

    struct scheduled_action_t* entry;
    struct scheduled_action_t* tmp;

    size_t processed = 0;

    LL_FOREACH_SAFE(first_to_process, entry, tmp)
    {
        entry->scheduled_action(entry->scheduled_action_data, entry->scheduled_action_response);
        processed++;

        if (entry->wait)
        {
            pthread_mutex_lock(entry->wait_mutex);
            // notify the waiter that we're done
            *entry->wait = 0;
            pthread_cond_signal(entry->wait_cond);
            pthread_mutex_unlock(entry->wait_mutex);
        }

        LL_DELETE(first_to_process, entry);
        free(entry);
    }

    pthread_mutex_lock(&main_thread_mutex);
    if (processed > 1) {
        bk.debug("Processed %d actions on main thread.\n", processed);
    }
    pthread_mutex_unlock(&main_thread_mutex);
}

int main(int argc, char **argv) {
    char* connect_host = NULL;
    int connect_port = 0;

    set_backend(gdb_backend);

    uint8_t debugger_mi2_mode = 0;
    char* map_file = NULL;

    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "-p") == 0) {
            connect_port = atoi(argv[++i]);
        } else if (strcmp(argv[i], "-h") == 0) {
            connect_host = argv[++i];
        } else if (strcmp(argv[i], "-x") == 0) {
            char* debug_symbols = argv[++i];
            if (bk.is_verbose()) {
                bk.debug("Reading debug symbols...");
            }
            read_symbol_file(debug_symbols);
            if (bk.is_verbose()) {
                bk.debug("OK\n");
            }
        } else if (strcmp(argv[i], "-v") == 0) {
            verbose = 1;
        } else if (strcmp(argv[i], "-q") == 0) {
            // ignore
        } else if (strcmp(argv[i], "--version") == 0) {
            bk.debug("GNU gdb (GDB) 11.0\n");
            bk.debug("The line above is fake, we're pretending to be a gdb here.\n");
            exit(0);
        } else if (strstr(argv[i], "--interpreter=")) {
            const char* interpreter = argv[i] + 14;
            if (strcmp(interpreter, "mi2") == 0) {
                debugger_mi2_mode = 1;
            }
        } else {
            if (map_file == NULL) {
                map_file = argv[i];
            } else {
                bk.debug("Unknown option: %s\n", argv[i]);
                exit(1);
            }
        }
    }

    debugger_init();
    init_mutexes();

    if (debugger_mi2_mode) {
        debugger_mi2_init();

        mi2_printf_thread("thread-group-added,id=\"i1\"");
        bk.console("z88dk-gdb, a gdb client for z88dk\n");

        if (map_file) {
            bk.debug("Reading symbol file %s...\n", map_file);
            debugger_read_symbol_file(map_file);
            bk.debug("Done.\n");
        }

        while (1) {
            registers_invalidated = 1;
            process_scheduled_actions();
        }

    } else {
        bk.debug("----------------------------------\n"
               "z88dk-gdb, a gdb client for z88dk.\n"
               "----------------------------------\n"
               "\n"
               "See the following for a list of compatible gdb servers: "
               "https://github.com/z88dk/z88dk/wiki/Tool-z88dk-gdb\n"
               "\n");

        if (connect_port == 0 || connect_host == NULL) {
            bk.debug("Usage: z88dk-gdb -h <connect host> -p <connect port> -x <debug symbols> [-x <debug symbols>] [-v]\n");
            return 1;
        } else {
            start_ctrl_c_signal_loop();

            bk.console("Connecting...\n");

            if (connect_to_gdbserver(connect_host, connect_port)) {
                bk.debug("Could not connect to the server\n");
                return 1;
            }

            bk.console("Connected to the server.\n");

            while (1) {
                registers_invalidated = 1;
                if (debugger_active) {
                    debugger();
                } else {
                    process_scheduled_actions();
                }
            }
        }
    }

    return 0;
}
