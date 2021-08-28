#ifndef BACKEND_H
#define BACKEND_H

#include <inttypes.h>

struct debugger_regs_t;

typedef uint8_t (*get_get_memory_cb)(uint16_t at);
typedef uint16_t (*get_uint16_cb)();
typedef long long (*get_longlong_cb)();
typedef int (*get_int_cb)();
typedef void (*reset_paging_cb)();
typedef void (*out_cb)(int port, int value);
typedef void (*debugger_write_memory_cb)(int addr, uint8_t val);
typedef void (*debugger_read_memory_cb)(int addr);
typedef void (*get_regs_cb)(struct debugger_regs_t* regs);
typedef void (*void_cb)();
typedef uint8_t (*breakpoints_check_cb)();
typedef void (*breakpoint_cb)(uint8_t type, uint16_t at, uint8_t sz);

enum bk_breakpoint_type
{
    BK_BREAKPOINT_SOFTWARE = 0,
    BK_BREAKPOINT_HARDWARE = 1,
    BK_BREAKPOINT_WATCHPOINT = 2,
    BK_BREAKPOINT_REGISTER = 2,
};

typedef struct {
    get_longlong_cb st;
    get_uint16_cb ff;
    get_uint16_cb pc;
    get_uint16_cb sp;
    get_get_memory_cb get_memory;
    get_regs_cb get_regs;
    get_regs_cb set_regs;
    get_int_cb f;
    get_int_cb f_;
    reset_paging_cb memory_reset_paging;
    out_cb out;
    debugger_write_memory_cb debugger_write_memory;
    debugger_read_memory_cb debugger_read_memory;
    void_cb invalidate;
    void_cb break_;
    void_cb resume;
    void_cb next;
    void_cb step;
    void_cb detach;
    breakpoint_cb add_breakpoint;
    breakpoint_cb remove_breakpoint;
    breakpoint_cb disable_breakpoint;
    breakpoint_cb enable_breakpoint;
    breakpoints_check_cb breakpoints_check;
} backend_t;

extern backend_t bk;

extern void set_backend(backend_t backend);

#endif