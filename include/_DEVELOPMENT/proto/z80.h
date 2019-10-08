include(__link__.m4)

#if __Z80 || __Z80N

#ifndef __Z80_H__
#define __Z80_H__

#include <stdint.h>
#include <im2.h>

__DPROTO(,,void,,z80_delay_ms,uint16_t ms)
__DPROTO(`d,e',`d,e',void,,z80_delay_tstate,uint16_t tstates)
__OPROTO(`b,c,d,e',`b,c,d,e',uint8_t,,z80_get_int_state,void)
__DPROTO(`a,b,c,d,e,h,l',`b,c,d,e',void,,z80_set_int_state,uint8_t state)

__DPROTO(`d,e',`d,e',uint8_t,,z80_inp,uint16_t port)
__DPROTO(`d,e',`d,e',void,*,z80_inir,void *dst,uint8_t port,uint8_t num)
__DPROTO(`d,e',`d,e',void,*,z80_indr,void *dst,uint8_t port,uint8_t num)
__DPROTO(`d,e',`d,e',void,,z80_outp,uint16_t port,uint8_t data)
__DPROTO(`d,e',`d,e',void,*,z80_otir,void *src,uint8_t port,uint8_t num)
__DPROTO(`d,e',`d,e',void,*,z80_otdr,void *src,uint8_t port,uint8_t num)

#define z80_bpoke(a,b)  (*(unsigned char *)(a) = b)
#define z80_wpoke(a,b)  (*(unsigned int *)(a) = b)
#define z80_lpoke(a,b)  (*(unsigned long *)(a) = b)

#define z80_bpeek(a)    (*(unsigned char *)(a))
#define z80_wpeek(a)    (*(unsigned int *)(a))
#define z80_lpeek(a)    (*(unsigned long *)(a))

#ifdef __CLANG

#define z80_llpoke(a,b) (*(unsigned long long *)(a) = b)
#define z80_llpeek(a)   (*(unsigned long long *)(a))

#endif

#ifdef __SDCC

#define z80_llpoke(a,b) (*(unsigned long long *)(a) = b)
#define z80_llpeek(a)   (*(unsigned long long *)(a))

#endif

#endif

#endif
