include(__link__.m4)

#ifndef _Z80_H
#define _Z80_H

#include <stdint.h>

__DPROTO(`b,c,d,e,h,l',`b,c,d,e',void,,im2_init,void *im2_table_address)
__DPROTO(`b,c',`b,c',void,*,im2_install_isr,uint16_t vector,void *isr)
__DPROTO(,,void,*,im2_create_generic_isr,uint16_t num_callbacks,void *address)
__DPROTO(,,void,*,im2_create_generic_isr_8080,uint16_t num_callbacks,void *address)
__DPROTO(,,void,,im2_append_generic_callback,uint16_t vector,void *callback)
__DPROTO(,,void,,im2_prepend_generic_callback,uint16_t vector,void *callback)
__DPROTO(,,int,,im2_remove_generic_callback,uint16_t vector,void *callback)

__DPROTO(,,void,,z80_delay_ms,uint16_t ms)
__DPROTO(`d,e',`d,e',void,,z80_delay_tstate,uint16_t tstates)
__OPROTO(`b,c,d,e',`b,c,d,e',uint16_t,,z80_get_int_state,void)
__DPROTO(`a,b,c,d,e,h,l',`b,c,d,e',void,,z80_set_int_state,uint16_t state)

__DPROTO(`d,e',`d,e',uint8_t,,z80_inp,uint16_t port)
__DPROTO(`d,e',`d,e',void,*,z80_inir,void *dst, uint16_t port)
__DPROTO(`d,e',`d,e',void,*,z80_indr,void *dst, uint16_t port)
__DPROTO(`d,e',`d,e',void,,z80_outp,uint16_t port,uint16_t data)
__DPROTO(`d,e',`d,e',void,*,z80_otir,void *src,uint16_t port)
__DPROTO(`d,e',`d,e',void,*,z80_otdr,void *src,uint16_t port)

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
