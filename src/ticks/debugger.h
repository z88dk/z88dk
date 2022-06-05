#ifndef DEBUGGER_H
#define DEBUGGER_H

#include <stdint.h>
#include <stddef.h>

#ifndef va_copy
#define va_copy(a,b) (a)=(b)
#endif

extern int debugger_active;
extern size_t current_frame;

extern void debugger_init();
extern void debugger();
int debugger_evaluate(char* line);
extern void debugger_request_a_break();

void stdout_log(const char *fmt, ...);

extern const char *resolve_to_label(int addr);
extern int parse_address(char *arg, const char** corrected_source);
extern void unwrap_reg(uint16_t data, uint8_t* h, uint8_t* l);
extern uint16_t wrap_reg(uint8_t h, uint8_t l);


#endif