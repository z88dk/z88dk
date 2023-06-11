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
#include <msx.h>

// Skip tape blocks until the type in a small header matches

int tape_load_block(void *addr, size_t len, unsigned char type)
{
char msx_type[2];
char msx_compare[2];

	do {
		msx_type[1]=msx_compare[1]=0;
		// unique identifier for the block type
		itoa(type,msx_compare,16);
		if (msxtape_load_block(msx_type, 2))
			return(-1);
	} while (strncmp(msx_type,msx_compare,2)!=0);

	if (msxtape_load_block(addr, len))
		return(-1);

	return(0);
}
