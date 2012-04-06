/*
 *	Took "as is" fron the Dominic's files
 *
 *	$Id: open_z88.c,v 1.3 2012-04-06 06:19:38 stefano Exp $
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
