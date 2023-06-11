/*
 *      Tape save routine
 *
 *		tape_save_block(void *addr, size_t len, unsigned char type)
 * 
 *      Stefano, 2022
 */

#define __HAVESEED
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <arch/mz.h>

__at (0x10F0) struct  mztapehdr mz_hdr;

int tape_save_block(void *addr, size_t len, unsigned char type)
{
char mz_type[3];

	memset(mz_type,0,3);
	itoa(type,mz_type,16);

	mz_hdr.type    = 3;
	mz_hdr.length  = 2;
	mz_hdr.address = mz_type;
	if (mztape_save_block(mz_type, 2))
		return(-1);

	mz_hdr.length  = len;
	mz_hdr.address = addr;
	if (mztape_save_block(addr, len))
		return(-1);

	return(0);
}
