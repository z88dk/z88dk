/*
 * Headerfile for Mattel Aquarius
 *
 * $Id: aquarius.h $
 */

#ifndef __AQUARIUS_H__
#define __AQUARIUS_H__

#include <sys/types.h>
#include <sound.h>

#ifdef __AQUARIUSPLUS__
#include <arch/aqplus.h>
#endif

////////////
// TAPE I/O
////////////


//#define tape_save_block(a,b,c) bit_save_block_zx_callee(a,b,c)
#define tape_save_block bit_save_block_zx

extern int  __LIB__            tape_load_block(void *addr, size_t len, unsigned char type) __smallc;
extern int  __LIB__  tape_load_block_callee(void *addr, size_t len, unsigned char type) __smallc __z88dk_callee;

#define tape_load_block(a,b,c) tape_load_block_callee(a,b,c)

// IO port definitions
static __sfr __at 0xF6 IO_PSG1DATA;
static __sfr __at 0xF7 IO_PSG1ADDR;
static __sfr __at 0xFC IO_CASSETTE;
static __sfr __at 0xFD IO_CPM;
static __sfr __at 0xFD IO_VSYNC;
static __sfr __at 0xFE IO_PRINTER;
static __sfr __at 0xFF IO_SCRAMBLE;


static __sfr __at 0x00FF IO_KEYBOARD_ALL;
static __sfr __at 0x7FFF IO_KEYBOARD_COL7;
static __sfr __at 0xBFFF IO_KEYBOARD_COL6;
static __sfr __at 0xDFFF IO_KEYBOARD_COL5;
static __sfr __at 0xEFFF IO_KEYBOARD_COL4;
static __sfr __at 0xF7FF IO_KEYBOARD_COL3;
static __sfr __at 0xFBFF IO_KEYBOARD_COL2;
static __sfr __at 0xFDFF IO_KEYBOARD_COL1;
static __sfr __at 0xFEFF IO_KEYBOARD_COL0;


#endif
