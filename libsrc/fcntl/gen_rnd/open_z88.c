/*
 *	Took "as is" fron the Dominic's files
 *
 *	$Id: open_z88.c,v 1.1 2014-01-14 07:48:41 stefano Exp $
 */

#include <fcntl.h>
#include <string.h>


int open_z88(far char *name, int flags, mode_t mode, char *buf,int len)
{
//	int  hand;

//	hand = open(name,flags,mode);

//	if ( hand != -1 ) { strncpy(buf,(near char *)name,len); }

//	return (hand);
return (open(name,flags,mode));
}
