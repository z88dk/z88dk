#ifndef __ARCH_MSX_ASM_H
#define __ARCH_MSX_ASM_H

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

typedef enum {
	REGS_NONE = 0,	//No registers at all
	REGS_AF = 1,	//AF only
	REGS_MAIN = 2,	//AF, BC, DE, HL
	REGS_ALL = 3	//AF, BC, DE, HL, IX, IY
} register_usage;


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


/* --- UNAPI code block  --- */

typedef struct {
	uint8_t UnapiCallCode[11];	/* Code to call the UNAPI entry point */
	uint8_t UnapiReadCode[13];	/* Code to read one uint8_t from the implementation, address is passed in HL */
} unapi_code_block;


/* ---  Generic assembler interop functions  --- */

//* Invoke a generic assembler routine.
//  regs is used for both input and output registers of the routine.
//  Depending on the values of inRegistersDetail and outRegistersDetail,
//  not all the registers will be passed from regs to the routine
//  and/or copied back to regs when the routine returns.
extern void __LIB__ AsmCall(uint16_t address, Z80_registers* regs, register_usage inRegistersDetail, register_usage outRegistersDetail) __z88dk_sdccdecl;

//* Execute a DOS function call,
//  it is equivalent to invoking address 5 with function number in register C.
extern void __LIB__ DosCall(uint8_t function, Z80_registers* regs, register_usage inRegistersDetail, register_usage outRegistersDetail) __z88dk_sdccdecl;

//* Invoke a MSX BIOS routine,
//  this is done via CALSLT to the slot specified in EXPTBL.
extern void __LIB__ BiosCall(uint16_t address, Z80_registers* regs, register_usage outRegistersDetail) __z88dk_sdccdecl;


/* --- UNAPI related functions  --- */

// * Get the number of installed implementations of a given specification
extern int __LIB__ UnapiGetCount(char* implIdentifier) __z88dk_sdccdecl;

// * Build code block for a given implementation,
//   code block can be later used in UnapiCall and UnapiRead.
//   implIdentifier may be NULL, then the identifier already at ARG 
//   (set for example by a previous call to UnapiGetCount) will be used.
extern void __LIB__ UnapiBuildCodeBlock(char* implIdentifier, int implIndex, unapi_code_block* codeBlock) __z88dk_sdccdecl;

// * Extract information about implementation location from a code block.
//   If address>=0xC000, slot and segment must be ignored.
//   Otherwise, if segment=0xFF, implementation is in ROM.
//   Otherwise, implementation is in mapped RAM.
extern void __LIB__ UnapiParseCodeBlock(unapi_code_block* codeBlock, uint8_t* slot, uint8_t* segment, uint16_t* address) __z88dk_sdccdecl;

//* Get the location of the RAM helper jump table and mapper table.
//  If RAM helper is not installed, jumpTableAddress will be zero.
extern void __LIB__ UnapiGetRamHelper(uint16_t* jumpTableAddress, uint16_t*  mapperTableAddress) __z88dk_sdccdecl;

//* Execute an UNAPI function.
//  Code block can be generated with UnapiBuildCodeBlock.
extern void __LIB__ UnapiCall(unapi_code_block* codeBlock, uint8_t functionNumber, Z80_registers* registers, register_usage inRegistersDetail, register_usage outRegistersDetail) __z88dk_sdccdecl;

//* Read one uint8_t from an UNAPI implementation.
//  Code block can be generated with UnapiBuildCodeBlock.
extern uint8_t __LIB__ UnapiRead(unapi_code_block* codeBlock, uint16_t address) __z88dk_sdccdecl;

#endif
