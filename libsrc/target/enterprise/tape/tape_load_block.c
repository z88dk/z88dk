/*
 *	Enterprise 64/128 tape libraries
 *
 *	tape_load_block(void *addr, size_t len, unsigned char type)
 *
 *	Stefano Bodrato - 2022
 *
 *	$Id: tape_load_block.c $
 */

#define __HAVESEED
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <enterprise.h>


int tape_load_block(void *addr, size_t len, unsigned char type)
{
	char devspec[]="TAPE-1:xxx";

	memset(devspec+7,0,3);
	itoa(type,devspec+7,16);

	if (exos_open_channel(111, devspec)) return (-1);
	if (exos_read_block(111, len, addr)) return (-1);
	if (exos_destroy_channel(111)) return (-1);
	return (0);	
}
