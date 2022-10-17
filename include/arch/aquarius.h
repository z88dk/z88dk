/*
 * Headerfile for Mattel Aquarius
 *
 * $Id: aquarius.h $
 */

#ifndef __AQUARIUS_H__
#define __AQUARIUS_H__

#include <sys/types.h>
#include <sound.h>


////////////
// TAPE I/O
////////////


//#define tape_save_block(a,b,c) bit_save_block_zx_callee(a,b,c)
#define tape_save_block bit_save_block_zx

extern int  __LIB__            tape_load_block(void *addr, size_t len, unsigned char type) __smallc;
extern int  __LIB__  tape_load_block_callee(void *addr, size_t len, unsigned char type) __smallc __z88dk_callee;

#define tape_load_block(a,b,c) tape_load_block_callee(a,b,c)




#endif
