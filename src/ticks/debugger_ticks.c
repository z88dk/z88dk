#include <stdio.h>
#include <stdarg.h>

#include "debugger.h"
#include "ticks.h"
#include "debug.h"
#include "backend.h"
#include "disassembler.h"
#include "breakpoints.h"

uint8_t verbose = 0;

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

uint8_t get_ticks_memory(uint16_t at)
{
    return get_memory(at);
}

uint8_t is_verbose()
{
    return verbose;
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
}

void debugger_write_memory(int addr, uint8_t val)
{
    breakpoint *elem;
    int         i = 0;
    LL_FOREACH(watchpoints, elem) {
        if ( elem->enabled == 0 ) {
            continue;
        }
        if ( elem->type == BREAK_WRITE && elem->value == addr ) {
            printf("Hit watchpoint %d\n",i);
            debugger_active = 1;
            break;
        }
        i++;
    }
}

void debugger_read_memory(int addr)
{
    breakpoint *elem;
    int         i = 0;

    LL_FOREACH(watchpoints, elem) {
        if ( elem->enabled == 0 ) {
            continue;
        }
        if ( elem->type == BREAK_READ && elem->value == addr ) {
            printf("Hit watchpoint %d\n",i);
            debugger_active = 1;
            break;
        }
        i++;
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

void next()
{
    char  buf[100];
    int   len;
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
            // It's a call
            add_temporary_internal_breakpoint(pc + len, TMP_REASON_ONE_INSTRUCTION, NULL, 0);
            debugger_active = 0;
            return;
        }
    }

    add_temp_breakpoint_one_instruction();
    debugger_active = 0;
}

void step()
{
    add_temp_breakpoint_one_instruction();
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
    return st;
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
    .remote_connect = NULL,
    .is_remote_connected = NULL,
    .console = stdout_log,
    .debug = stdout_log,
    .execution_stopped = NULL,
    .ctrl_c = ctrl_c,
    .time = ticks_time
};
