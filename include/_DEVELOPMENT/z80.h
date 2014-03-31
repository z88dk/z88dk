
#ifndef _Z80_H
#define _Z80_H

#include <_DEVELOPMENT/stdint.h>

// SCCZ80

extern void   __LIB__ __FASTCALL__  z80_delay_ms(uint16_t ms);
extern void   __LIB__ __FASTCALL__  z80_delay_tstate(uint16_t tstates);
extern void   __LIB__               z80_pop_int_state(void);
extern void   __LIB__               z80_push_int_state(void);

// SCCZ80 CALLEE LINKAGE

// SCCZ80 MAKE CALLEE LINKAGE THE DEFAULT

#endif
