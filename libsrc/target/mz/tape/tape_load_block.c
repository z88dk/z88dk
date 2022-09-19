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
		if (mztape_load_block(mz_type, 2))
			return(-1);
	} while (strncmp(mz_type,mz_compare,2)!=0);

	if (mztape_load_block(addr, len))
		return(-1);

	return(0);
}
