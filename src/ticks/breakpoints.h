#ifndef BREAKPOINTS_H
#define BREAKPOINTS_H

#include <stdint.h>
#include "debug.h"

enum bk_breakpoint_type
{
    BK_BREAKPOINT_SOFTWARE = 0,
    BK_BREAKPOINT_HARDWARE = 1,
    BK_BREAKPOINT_WATCHPOINT = 2,
    BK_BREAKPOINT_REGISTER = 2,
};

typedef enum {
    BREAK_PC,
    BREAK_REGISTER,
    BREAK_CHECK8,
    BREAK_CHECK16,
    BREAK_READ,
    BREAK_WRITE,
} breakpoint_type;

typedef struct breakpoint {
    breakpoint_type         type;
    int                     value;
    unsigned char           lvalue;
    uint16_t                lcheck_arg;
    unsigned char           hvalue;
    uint16_t                hcheck_arg;

    uint8_t                 pending_add;
    uint8_t                 pending_remove;

    int                     number;
    char                    enabled;
    char                    *text;
    struct breakpoint       *next;
} breakpoint;

typedef enum {
    TMP_REASON_UNKNOWN = 0,
    TMP_REASON_FIN,
    TMP_REASON_STEP_SOURCE_LINE,
    TMP_REASON_NEXT_SOURCE_LINE,
    TMP_REASON_ONE_INSTRUCTION,
} temporary_breakpoint_reason_t;

#define TEMP_BREAKPOINT_ANYWHERE (0xFFFFFFFF)

typedef struct temporary_breakpoint_t {
    temporary_breakpoint_reason_t   reason;
    uint32_t                        at;
    debug_sym_function*             callee;
    const char*                     source_file;
    int                             source_line;
    uint8_t                         external;
    struct temporary_breakpoint_t*  next;
} temporary_breakpoint_t;

extern breakpoint *breakpoints;
extern breakpoint *watchpoints;
extern temporary_breakpoint_t* temporary_breakpoints;
extern int next_breakpoint_number;

extern breakpoint* add_breakpoint(breakpoint_type type, enum bk_breakpoint_type bk_type, int bk_size, int value, const char* text);
extern breakpoint* add_watchpoint(breakpoint_type operation, int value);
extern void delete_breakpoint(breakpoint* b);
extern void delete_watchpoint(breakpoint* w);
extern void delete_all_breakpoints();
extern breakpoint* find_breakpoint(int number);
extern breakpoint* find_watchpoint(int number);

extern temporary_breakpoint_t* add_temp_breakpoint_one_instruction();
extern temporary_breakpoint_t* add_temporary_internal_breakpoint(uint32_t address, temporary_breakpoint_reason_t reason,
    const char *source_filename, int source_lineno);
extern void remove_temp_breakpoint(temporary_breakpoint_t* b);
extern void remove_temp_breakpoints();
extern uint8_t process_temp_breakpoints();

#endif
