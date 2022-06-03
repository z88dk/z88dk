#ifndef DEBUGGER_H
#define DEBUGGER_H

#include <stdint.h>

extern int debugger_active;
extern void      debugger_init();
extern void      debugger();
extern void      debugger_process_signals();

extern void unwrap_reg(uint16_t data, uint8_t* h, uint8_t* l);
extern uint16_t wrap_reg(uint8_t h, uint8_t l);


#endif