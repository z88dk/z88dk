
#ifndef _Z80_H
#define _Z80_H

#include <stdint.h>

#if __SDCC | __SDCC_IX | __SDCC_IY

// SDCC

extern void       z80_delay_ms(uint16_t ms);
extern void       z80_delay_tstate(uint16_t tstates);
extern uint16_t   z80_get_int_state(void);
extern void       z80_set_int_state(uint16_t state);

#else

// SCCZ80

extern void       __LIB__ __FASTCALL__  z80_delay_ms(uint16_t ms);
extern void       __LIB__ __FASTCALL__  z80_delay_tstate(uint16_t tstates);
extern uint16_t   __LIB__               z80_get_int_state(void);
extern void       __LIB__ __FASTCALL__  z80_set_int_state(uint16_t state);

// SCCZ80 CALLEE LINKAGE

// SCCZ80 MAKE CALLEE LINKAGE THE DEFAULT

#endif

#endif
