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

int tape_save_block(void *addr, size_t len, unsigned char type)
{
char mz_type[2];

	mz_type[1]=0;
	itoa(type,mz_type,16);

	if (mztape_save_block(mz_type, 2))
		return(-1);

	if (mztape_save_block(addr, len))
		return(-1);

	return(0);
}
