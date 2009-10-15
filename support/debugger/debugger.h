#ifndef DEBUGGER__H
#define DEBUGGER__H

/** Had to make these external for compile to work... strange... */

extern void debugger_set_break(unsigned char* addr);

extern int debugger_num_break_bytes();

extern int debugger_exchange_str(void *ptr, int len);


#endif
