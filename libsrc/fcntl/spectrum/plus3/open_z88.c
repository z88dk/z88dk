/*
 *	Spectrum +3 file support
 *
 *	djm 30/4/2001
 *
 *	$Id: open_z88.c,v 1.1 2001-05-01 13:55:21 dom Exp $
 */

#include <fcntl.h>
#include <string.h>
#include <spectrum.h>



int open_z88(far char *name, int flags, mode_t mode, char *buf,int len)
{
	int  hand;

	hand = open(name,flags,mode);

	if ( hand != -1 ) {
		strncpy(buf,(near char *)name,len);
	}
	return (hand);
}



