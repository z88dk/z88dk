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
#include <msx.h>

int tape_save_block(void *addr, size_t len, unsigned char type)
{
char msx_type[3];

	memset(msx_type,0,3);
	itoa(type,msx_type,16);

	if (msxtape_save_header(msx_type, 2))
		return(-1);

	if (msxtape_save_block(addr, len))
		return(-1);

	return(0);
}
