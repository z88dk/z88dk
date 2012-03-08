/*
 *	Took "as is" fron the Dominic's files
 *
 *	$Id: open_z88.c,v 1.1 2012-03-08 07:16:46 stefano Exp $
 */

#include <fcntl.h>
#include <string.h>
#include <flos.h>


int open_z88(far char *name, int flags, mode_t mode, char *buf,int len)
{
	int  hand;

	hand = open(name,flags,mode);

	if ( hand != -1 ) { strncpy(buf,(near char *)name,len); }

	return (hand);
}
