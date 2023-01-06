#ifndef __ARCH_Z80_ASM_H
#define __ARCH_Z80_ASM_H

/*
 * ASMLIB - SDCC library for assembler and UNAPI interop v1.0
 * By Konamiman, 2/2010
 * https://github.com/Konamiman/MSX/tree/master/SRC/SDCC/asmlib
 */

#include <sys/compiler.h>
#include <sys/types.h>
#include <stdint.h>

#ifndef NULL
#define NULL (void*)0
#endif

/* ---  Register detail levels  --- */

// This value tells which registers to pass in/out
// to the routine invoked by AsmCall, DosCall, BiosCall
// and UnapiCall.

typedef unsigned char register_usage;

enum {
	REGS_NONE = 0,	//No registers at all
	REGS_AF = 1,	//AF only
	REGS_MAIN = 2,	//AF, BC, DE, HL
	REGS_ALL = 3	//AF, BC, DE, HL, IX, IY
};


/* ---  Structure representing the Z80 registers  ---
        Registers can be accesses as:
        Signed or unsigned words (ex: regs.Words.HL, regs.UWords.HL)
        Bytes (ex: regs.Bytes.A)
        Flags (ex: regs.Flags.Z)
 */

typedef union {
	struct {
	    uint8_t F;
	    uint8_t A;
	    uint8_t C;
		uint8_t B;
		uint8_t E;
		uint8_t D;
		uint8_t L;
		uint8_t H;
		uint8_t IXl;
		uint8_t IXh;
		uint8_t IYl;
		uint8_t IYh;
    } Bytes;
	struct {
	    int AF;
	    int BC;
	    int DE;
	    int HL;
	    int IX;
	    int IY;
    } Words;
	struct {
	    uint16_t AF;
	    uint16_t BC;
	    uint16_t DE;
	    uint16_t HL;
	    uint16_t IX;
	    uint16_t IY;
    } UWords;
#ifdef __SCCZ80
	struct {
		unsigned C:1;
		unsigned N:1;
		unsigned PV:1;
		unsigned bit3:1;
		unsigned H:1;
		unsigned bit5:1;
		unsigned Z:1;
		unsigned S:1;
	} Flags;
#endif
} Z80_registers;


/* ---  Generic assembler interop functions  --- */

//* Invoke a generic assembler routine.
//  regs is used for both input and output registers of the routine.
//  Depending on the values of inRegistersDetail and outRegistersDetail,
//  not all the registers will be passed from regs to the routine
//  and/or copied back to regs when the routine returns.
extern void __LIB__ AsmCall(uint16_t address, Z80_registers* regs, register_usage inRegistersDetail, register_usage outRegistersDetail) __z88dk_sdccdecl;



// Useful routines originally from newlib

extern void __LIB__ z80_delay_ms(uint16_t ms) __smallc __z88dk_fastcall;


extern void __LIB__ z80_delay_tstate(uint16_t tstates) __smallc __z88dk_fastcall;


extern uint8_t __LIB__ z80_get_int_state(void) __smallc;


extern void __LIB__ z80_set_int_state(uint8_t state) __smallc __z88dk_fastcall;



extern uint8_t __LIB__ z80_inp(uint16_t port) __smallc __z88dk_fastcall;


extern void __LIB__ *z80_inir(void *dst,uint8_t port,uint8_t num) __smallc;
extern void __LIB__ *z80_inir_callee(void *dst,uint8_t port,uint8_t num) __smallc __z88dk_callee;
#define z80_inir(a,b,c) z80_inir_callee(a,b,c)


extern void __LIB__ *z80_indr(void *dst,uint8_t port,uint8_t num) __smallc;
extern void __LIB__ *z80_indr_callee(void *dst,uint8_t port,uint8_t num) __smallc __z88dk_callee;
#define z80_indr(a,b,c) z80_indr_callee(a,b,c)


extern void __LIB__ z80_outp(uint16_t port,uint8_t data) __smallc;
extern void __LIB__ z80_outp_callee(uint16_t port,uint8_t data) __smallc __z88dk_callee;
#define z80_outp(a,b) z80_outp_callee(a,b)


extern void __LIB__ *z80_otir(void *src,uint8_t port,uint8_t num) __smallc;
extern void __LIB__ *z80_otir_callee(void *src,uint8_t port,uint8_t num) __smallc __z88dk_callee;
#define z80_otir(a,b,c) z80_otir_callee(a,b,c)


extern void __LIB__ *z80_otdr(void *src,uint8_t port,uint8_t num) __smallc;
extern void __LIB__ *z80_otdr_callee(void *src,uint8_t port,uint8_t num) __smallc __z88dk_callee;
#define z80_otdr(a,b,c) z80_otdr_callee(a,b,c)



#define z80_bpoke(a,b)  (*(unsigned char *)(a) = b)
#define z80_wpoke(a,b)  (*(unsigned int *)(a) = b)
#define z80_lpoke(a,b)  (*(unsigned long *)(a) = b)

#define z80_bpeek(a)    (*(unsigned char *)(a))
#define z80_wpeek(a)    (*(unsigned int *)(a))
#define z80_lpeek(a)    (*(unsigned long *)(a))

#define z80_llpoke(a,b) (*(unsigned long long *)(a) = b)
#define z80_llpeek(a)   (*(unsigned long long *)(a))



#endif
