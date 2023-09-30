#ifndef BACKEND_H
#define BACKEND_H

#include "breakpoints.h"
#include "memory.h"
#include <inttypes.h>

struct debugger_regs_t;

typedef uint8_t (*get_get_memory_cb)(uint32_t at, memtype type);
typedef uint16_t (*get_uint16_cb)();
typedef long long (*get_longlong_cb)();
typedef char* (*get_charp_cb)();
typedef int (*get_int_cb)();
typedef void (*reset_paging_cb)();
typedef uint8_t (*restore_cb)(const char* file_path, uint16_t at, uint8_t set_pc);
typedef void (*out_cb)(int port, int value);
typedef void (*debugger_write_memory_cb)(int addr, uint8_t val);
typedef void (*debugger_read_memory_cb)(int addr);
typedef void (*get_regs_cb)(struct debugger_regs_t* regs);
typedef void (*break_cb)(uint8_t temporary);
typedef void (*void_cb)();
typedef void (*step_cb)(uint8_t add_bp);
typedef uint8_t (*uint8_t_cb)();
typedef uint32_t (*uint32_t_cb)();
typedef void (*log_cb)(const char *fmt, ...);
typedef uint8_t (*breakpoints_check_cb)();

typedef enum
{
    BREAKPOINT_ERROR_OK = 0,
    BREAKPOINT_ERROR_NOT_CONNECTED,
    BREAKPOINT_ERROR_RUNNING,
    BREAKPOINT_ERROR_FAILURE,
} breakpoint_ret_t;

typedef breakpoint_ret_t (*breakpoint_cb)(uint8_t type, uint16_t at, uint8_t sz);
typedef uint8_t (*connect_cb)(const char* hostname, int port);

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
    uint8_t breakable;
    break_cb break_;
    void_cb resume;
    step_cb next;
    step_cb step;
    void_cb detach;
    uint8_t confirm_detach_w_breakpoints;
    restore_cb restore;
    breakpoint_cb add_breakpoint;
    breakpoint_cb remove_breakpoint;
    breakpoint_cb disable_breakpoint;
    breakpoint_cb enable_breakpoint;
    breakpoints_check_cb breakpoints_check;
    uint8_t_cb is_verbose;
    log_cb console;
    log_cb debug;
    connect_cb remote_connect;
    uint8_t_cb is_remote_connected;
    void_cb execution_stopped;
    void_cb ctrl_c;
    uint32_t_cb time;
	get_charp_cb script_filename;
} backend_t;

extern backend_t bk;

extern void set_backend(backend_t backend);

#endif
