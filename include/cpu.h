#ifndef __CPU_H__
#define __CPU_H__

#include <sys/compiler.h>
#include <stdint.h>

/*
 * Classic counterpart of newlib <cpu.h>.
 * Z80: cpu_* names alias the existing z80_* wrappers in <arch/z80.h>.
 * Z180/8080/8085/gbz80/vm1: cpu_delay_ms is a stdlib alias of
 * asm_cpu_delay_ms. 8080-family skips <arch/z80.h> (inir/otir are Z80-only).
 */

#if __Z180

#include <arch/z80.h>

/* Classic z180 clib has no z80_delay_ms wrapper; use stdlib cpu_delay_*. */
extern void __LIB__ cpu_delay_ms(uint16_t ms) __smallc __z88dk_fastcall;
extern void __LIB__ cpu_delay_tstate(uint16_t tstates) __smallc __z88dk_fastcall;

#define cpu_get_int_state  z80_get_int_state
#define cpu_set_int_state  z80_set_int_state

#define cpu_inp   z80_inp
#define cpu_outp  z80_outp
#define cpu_inir  z80_inir
#define cpu_indr  z80_indr
#define cpu_otir  z80_otir
#define cpu_otdr  z80_otdr

#elif __Z80 || __Z80N || defined(__Z80__)

#include <arch/z80.h>

#define cpu_delay_ms       z80_delay_ms
#define cpu_delay_tstate   z80_delay_tstate

#define cpu_get_int_state  z80_get_int_state
#define cpu_set_int_state  z80_set_int_state

#define cpu_inp   z80_inp
#define cpu_outp  z80_outp
#define cpu_inir  z80_inir
#define cpu_indr  z80_indr
#define cpu_otir  z80_otir
#define cpu_otdr  z80_otdr

#elif __8080 || __8085 || __GBZ80 || defined(__GBZ80__) || __VM1

extern void __LIB__ cpu_delay_ms(uint16_t ms) __smallc __z88dk_fastcall;
extern void __LIB__ cpu_delay_tstate(uint16_t tstates) __smallc __z88dk_fastcall;

#endif

#define cpu_bpoke(a,b)  (*(unsigned char *)(a) = b)
#define cpu_wpoke(a,b)  (*(unsigned int *)(a) = b)
#define cpu_lpoke(a,b)  (*(unsigned long *)(a) = b)

#define cpu_bpeek(a)    (*(unsigned char *)(a))
#define cpu_wpeek(a)    (*(unsigned int *)(a))
#define cpu_lpeek(a)    (*(unsigned long *)(a))

#ifdef __CLANG

#define cpu_llpoke(a,b) (*(unsigned long long *)(a) = b)
#define cpu_llpeek(a)   (*(unsigned long long *)(a))

#endif

#ifdef __SDCC

#define cpu_llpoke(a,b) (*(unsigned long long *)(a) = b)
#define cpu_llpeek(a)   (*(unsigned long long *)(a))

#endif

#endif
