#ifndef DEBUGGER_GDB_H
#define DEBUGGER_GDB_H

#include <stdint.h>

typedef void (*trapped_action_t)(const void* data, void* response);
typedef void (*network_op_cb)(void* arg);

struct network_op
{
    network_op_cb callback;
    void* arg;
    struct network_op* prev;
};

extern void execute_on_main_thread(trapped_action_t call, const void* data, void* response);
extern void execute_on_main_thread_no_response(trapped_action_t call, const void* data);
extern char *mem2hex(const uint8_t *mem, char *buf, uint32_t count);

extern void debugger_gdb_break(uint8_t temporary);

extern uint8_t temporary_break;

#endif