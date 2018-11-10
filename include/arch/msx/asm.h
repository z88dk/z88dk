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
#include <arch/z80.h>


/* --- UNAPI code block  --- */

typedef struct {
	uint8_t UnapiCallCode[11];	/* Code to call the UNAPI entry point */
	uint8_t UnapiReadCode[13];	/* Code to read one uint8_t from the implementation, address is passed in HL */
} unapi_code_block;

/* ---  Generic assembler interop functions  --- */

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
