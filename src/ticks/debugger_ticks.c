#include <stdio.h>
#include <stdarg.h>

#include "debugger.h"
#include "ticks.h"
#include "debug.h"
#include "backend.h"
#include "disassembler.h"
#include "breakpoints.h"

uint8_t verbose = 0;
char* script_file = NULL;

long long get_st()
{
    return st;
}

uint16_t get_ff()
{
    return ff;
}

uint16_t get_pc()
{
    return pc;
}

uint16_t get_sp()
{
    return sp;
}

uint8_t get_ticks_memory(uint32_t at, memtype type)
{
    /* Above 64k the debugger means a bank:address in the banked memory model */
    if ( at > 0xffff && !memory_uses_lua() )
        return *memory_debug_addr(at, type);
    return get_memory(at, type);
}

static uint32_t get_banked_pc()
{
    return memory_banked_pc(pc);
}

/* banked_call keeps the real return address and the saved bank on a separate
   stack, whose pointer is ___z88dk_banked_banksp. Each banked call that is
   still running has an entry: the return address, then af with the bank in a. */
static int get_banked_caller(unsigned depth, uint32_t *caller)
{
    int      var = symbol_resolve("___z88dk_banked_banksp", NULL);
    uint16_t sp, entry, saved;

    /* Debugger reads must not trigger watchpoints */
#define PEEK(a) peek_memory((uint16_t)(a), MEM_TYPE_DATA)
    if ( var < 0 )
        return 0;
    sp = PEEK(var) | PEEK(var + 1) << 8;
    entry = sp + depth * 4;
    if ( entry < sp )
        return 0;
    /* The Rabbit 4000 and later save the whole LXPC as a word, the others save
       af with the bank in a */
    if ( israbbit() && (c_cpu & (CPU_R4K|CPU_R6K)) )
        saved = PEEK(entry + 2) | PEEK(entry + 3) << 8;
    else
        saved = PEEK(entry + 3);
    *caller = memory_banked_caller(saved, PEEK(entry) | PEEK(entry + 1) << 8);
#undef PEEK
    return 1;
}

static char* get_mmu_info()
{
    return (char *)memory_mmu_text();
}

uint8_t is_verbose()
{
    return verbose;
}

char* script_filename() {
	return script_file;
}

void get_regs(struct debugger_regs_t* regs)
{
    regs->sp = sp;
    regs->pc = pc;

    regs->a = a;
    regs->b = b;
    regs->c = c;
    regs->d = d;
    regs->e = e;
    regs->h = h;
    regs->l = l;

    regs->a_ = a_;
    regs->b_ = b_;
    regs->c_ = c_;
    regs->d_ = d_;
    regs->e_ = e_;
    regs->h_ = h_;
    regs->l_ = l_;

    regs->xh = xh;
    regs->xl = xl;
    regs->yh = yh;
    regs->yl = yl;

    /* The VM1's RS prefix is implemented by exchanging h/l with h_/l_ for the
       duration of one instruction, so when we stop between a prefix and its
       instruction the pair are the wrong way round. Report them logically:
       hl is always HL and hl' is always H1L1. */
    if ( vm1_rs == 1 ) {
        regs->h = h_;  regs->l = l_;
        regs->h_ = h;  regs->l_ = l;
    }
}

void set_regs(struct debugger_regs_t* regs)
{
    sp = regs->sp;
    pc = regs->pc;

    a = regs->a;
    b = regs->b;
    c = regs->c;
    d = regs->d;
    e = regs->e;
    h = regs->h;
    l = regs->l;

    a_ = regs->a_;
    b_ = regs->b_;
    c_ = regs->c_;
    d_ = regs->d_;
    e_ = regs->e_;
    h_ = regs->h_;
    l_ = regs->l_;

    xh = regs->xh;
    xl = regs->xl;
    yh = regs->yh;
    yl = regs->yl;

    /* Mirror of the exchange in get_regs() */
    if ( vm1_rs == 1 ) {
        h = regs->h_;  l = regs->l_;
        h_ = regs->h;  l_ = regs->l;
    }
}

/* A watchpoint above 64k is a banked address (bank << 16 | address in the bank
   window). It matches an access through the window while its bank is mapped. */
static int watch_matches(const breakpoint *elem, int addr)
{
    if ( elem->value > 0xffff )
        return addr >= 0 && addr <= 0xffff && elem->value == (int)memory_banked_pc(addr);
    return elem->value == addr;
}

void debugger_write_memory(int addr, uint8_t val)
{
    breakpoint *elem;
    int         i = 0;      /* the number that the watch command shows */
    LL_FOREACH(watchpoints, elem) {
        i++;
        if ( elem->enabled == 0 ) {
            continue;
        }
        if ( elem->type == BREAK_WRITE && watch_matches(elem, addr) ) {
            printf("Hit watchpoint %d\n",i);
            debugger_active = 1;
            break;
        }
    }
}

void debugger_read_memory(int addr)
{
    breakpoint *elem;
    int         i = 0;

    LL_FOREACH(watchpoints, elem) {
        i++;
        if ( elem->enabled == 0 ) {
            continue;
        }
        if ( elem->type == BREAK_READ && watch_matches(elem, addr) ) {
            printf("Hit watchpoint %d\n",i);
            debugger_active = 1;
            break;
        }
    }
}

void invalidate() {}
void break_(uint8_t temporary) {debugger_active=1; }
void resume() {}
void detach() {}
uint8_t restore(const char* file_path, uint16_t at, uint8_t set_pc) {
    printf("Not supported.\n");
    return 1;
}

static breakpoint_ret_t do_nothing(uint8_t type, uint16_t at, uint8_t sz) { return BREAKPOINT_ERROR_OK; }

void next(uint8_t add_bp)
{
    static char buf[2048];
    int len;
    const unsigned short pc = bk.pc();

    uint8_t opcode = bk.get_memory(pc, MEM_TYPE_INST);

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
            // It's a call
            if (add_bp) {
                add_temporary_internal_breakpoint(pc + len, TMP_REASON_ONE_INSTRUCTION, NULL, 0);
            }
            debugger_active = 0;
            return;
        }
    }

    if (add_bp) {
        add_temp_breakpoint_one_instruction();
    }
    debugger_active = 0;
}

void step(uint8_t add_bp)
{
    if (add_bp) {
        add_temp_breakpoint_one_instruction();
    }
    debugger_active = 0;
}

static void ctrl_c()
{
    break_required = 1;
}

uint8_t breakpoints_check()
{
    return debugger_active == 0;
}

static uint32_t ticks_time()
{
    return (uint32_t)st;
}

static void ticks_remote_closed()
{
    // do nothing
}

backend_t ticks_debugger_backend = {
    .st = &get_st,
    .ff = &get_ff,
    .pc = &get_pc,
    .sp = &get_sp,
    .get_memory = &get_ticks_memory,
    .get_regs = &get_regs,
    .set_regs = &set_regs,
    .f = &f,
    .f_ = &f_,
    .memory_reset_paging = &memory_reset_paging,
    .out = &out,
    .debugger_write_memory = &debugger_write_memory,
    .debugger_read_memory = &debugger_read_memory,
    .invalidate = &invalidate,
    .breakable = 1,
    .break_ = &break_,
    .resume = &resume,
    .next = &next,
    .step = &step,
    .confirm_detach_w_breakpoints = 0,
    .detach = &detach,
    .restore = &restore,
    .add_breakpoint = &do_nothing,
    .remove_breakpoint = &do_nothing,
    .disable_breakpoint = &do_nothing,
    .enable_breakpoint = &do_nothing,
    .breakpoints_check = &breakpoints_check,
    .is_verbose = is_verbose,
	.script_filename = script_filename,
    .remote_connect = NULL,
    .is_remote_connected = NULL,
    .send_remote_command = NULL,
    .console = stdout_log,
    .console_raw = stdout_log_raw,
    .debug = stdout_log,
    .execution_stopped = NULL,
    .ctrl_c = ctrl_c,
    .time = ticks_time,
    .remote_closed = ticks_remote_closed,
    .banked_pc = get_banked_pc,
    .mmu_info = get_mmu_info,
    .banked_caller = get_banked_caller,
};
