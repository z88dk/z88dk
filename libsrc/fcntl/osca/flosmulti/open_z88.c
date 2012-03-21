/*
 *	Took "as is" from the Dominic's files
 *
 *	$Id: open_z88.c,v 1.1 2012-03-21 10:20:23 stefano Exp $
 */

#include <fcntl.h>
#include <string.h>
#include <flos.h>


int open_z88(far char *name, mode_t mode, int flags, char *buf,int len)
{
	int  hand;

	hand = open(name,flags,mode);

	if ( hand != -1 ) { strncpy(buf,(near char *)name,len); }

	return (hand);
}
