/*
 *	Took "as is" fron the Dominic's files
 *
 *	$Id: open_z88.c,v 1.1 2005-02-18 08:35:53 stefano Exp $
 */

#include <fcntl.h>
#include <string.h>
#include <spectrum.h>


int open_z88(far char *name, int flags, mode_t mode, char *buf,int len)
{
	int  hand;

	hand = open(name,flags,mode);

	if ( hand != -1 ) { strncpy(buf,(near char *)name,len); }

	return (hand);
}
