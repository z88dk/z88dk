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

extern const char* register_mapping_names[];

extern void execute_on_main_thread(trapped_action_t call, const void* data, void* response);
extern void execute_on_main_thread_no_response(trapped_action_t call, const void* data);
extern char *mem2hex(const uint8_t *mem, char *buf, uint32_t count);

extern void debugger_gdb_break(uint8_t temporary);

extern uint8_t temporary_break;

#endif