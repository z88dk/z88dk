/*
 *	Enterprise 64/128 tape libraries
 *
 *	tape_save(void *addr, size_t len, unsigned char type)
 *
 *	Stefano Bodrato - 2022
 *
 *	$Id: tape_save.c $
 */

#define __HAVESEED
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <enterprise.h>

int tape_save(char *name, void *addr, size_t len)
{
	struct EXOS_STRING devspec;
	
	strcpy(devspec.text, "TAPE-1:");
	strcat(devspec.text, name);
	devspec.len=strlen(devspec.text);

	if (exos_create_channel(111, devspec)) return (-1);
	if (exos_write_block(111, len, addr)) return (-1);
	if (exos_destroy_channel(111)) return (-1);
	return (0);	
}
