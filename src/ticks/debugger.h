#ifndef DEBUGGER_H
#define DEBUGGER_H

#include <stdint.h>

typedef enum {
    BREAK_PC,
    BREAK_REGISTER,
    BREAK_CHECK8,
    BREAK_CHECK16,
    BREAK_READ,
    BREAK_WRITE,
} breakpoint_type;

typedef struct breakpoint {
    breakpoint_type    type;
    int                value;
    unsigned char      lvalue;
    uint16_t           lcheck_arg;
    unsigned char      hvalue;
    uint16_t           hcheck_arg;
    char               enabled;
    char               *text;
    struct breakpoint  *next;
} breakpoint;

struct debugger_regs_t {
    uint16_t pc, sp;
    unsigned char a,b,c,d,e,h,l;
    unsigned char a_,b_,c_,d_,e_,h_,l_;
    unsigned char f, f_;
    unsigned char xh, xl, yh, yl;
};

extern int debugger_active;
extern void      debugger_init();
extern void      debugger();

extern void unwrap_reg(uint16_t data, uint8_t* h, uint8_t* l);
extern uint16_t wrap_reg(uint8_t h, uint8_t l);


#endif