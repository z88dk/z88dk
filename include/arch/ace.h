/*
 * Headerfile for Jupiter ACE specific stuff
 *
 * $Id: ace.h $
 */

#ifndef __ACE_H__
#define __ACE_H__

#include <sys/types.h>

/////////////
// CONSTANTS
/////////////

// Text attributes

#define INVERSE        0x80


///////////////////////////////////////////
// DIAGNOSTICS AND HARDWARE IDENTIFICATION
///////////////////////////////////////////

extern int  __LIB__ ace_freemem(void);

//////////////
// ZX PRINTER
//////////////

extern void __LIB__  zx_hardcopy();
// Print out a 256 bytes buffer (8 rows)
extern void __LIB__  zx_print_buf(char *buf) __z88dk_fastcall;
// Print out a single graphics row (a 32 bytes buffer is required)
extern void __LIB__  zx_print_row(char *buf) __z88dk_fastcall;


////////////
// TAPE I/O
////////////

struct acetapehdr {             // standard tape header
   unsigned char type;
   char          name[10];
   size_t        length;
   size_t        address;
   size_t        offset;
   char          name2[10];
};

extern int  __LIB__            tape_save(char *name, size_t loadstart,void *start, size_t len) __smallc;
extern int  __LIB__            tape_save_block(void *addr, size_t len, unsigned char type) __smallc;
extern int  __LIB__            tape_load_block(void *addr, size_t len, unsigned char type) __smallc;

extern int  __LIB__  tape_save_block_callee(void *addr, size_t len, unsigned char type)  __smallc __z88dk_callee;
extern int  __LIB__  tape_load_block_callee(void *addr, size_t len, unsigned char type) __smallc __z88dk_callee;

#define tape_save_block(a,b,c) tape_save_block_callee(a,b,c)
#define tape_load_block(a,b,c) tape_load_block_callee(a,b,c)



#endif
