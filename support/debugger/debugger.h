#ifndef DEBUGGER__H
#define DEBUGGER__H

/** Had to make these external for compile to work... strange... */

/**
 *  This is called to set a breakpoint at the specific address for a specific target
 */
extern void debugger_set_break(unsigned char* addr);

/**
 *  This is called to know the number of bytes in breakpoints (some targets cannot
 *  use the rst XXh as breakpoints so has to be a jp, call or else)
 *  In that case, if one is to support multiple breakpoints in the future, care must be
 *  taken not to overlap breakpoints!
 *
 *  In most instances, this is just a function returning 1
 */
extern int debugger_num_break_bytes();


/**
 *  This is called from debugger, here we should use the platform specific 
 *  code (probably assembler) that will first send the string ptr, with len
 *  via the serial line or similar, then on return, we must see to it that the ptr
 *  contains the reply from the debugger binary, with the length as a return value
 *
 */
extern int debugger_exchange_str(void *ptr, int len);


#endif
