/*
 *      Tape load routine
 *
 *		tape_load_block(void *addr, size_t len, unsigned char type)
 * 
 *      Stefano, 2022
 */

#define __HAVESEED
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <arch/mz.h>

// Skip tape blocks until the type in a small header matches

int tape_load_block(void *addr, size_t len, unsigned char type)
{
char mz_type[2];
char mz_compare[2];

	do {
		mz_type[1]=mz_compare[1]=0;
		// unique identifier for the block type
		itoa(type,mz_compare,16);
		mz_hdr.type    = 3;
		mz_hdr.length  = 2;
		mz_hdr.address = mz_type;
		if (mztape_load_block(mz_type, 2))
			return(-1);
	} while (strncmp(mz_type,mz_compare,2)!=0);

	mz_hdr.type    = 3;
	mz_hdr.length  = len;
	mz_hdr.address = addr;
	if (mztape_load_block(addr, len))
		return(-1);

	return(0);
}
