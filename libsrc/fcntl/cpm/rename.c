/*
 *   Rename a file - CP/M version
 *
 *	 Stefano Bodrato - Oct. 2004
 *
 *   $Id: rename.c,v 1.2 2016-04-23 08:05:41 dom Exp $
 */

#include <cpm.h>
#include <fcntl.h>
#include <stdio.h>

/* Buffer for a whole FCB area (42 bytes) preceeded by a partial one (16 bytes)..
   Total would be 58 bytes  */

char buff[60];

int rename(char *old, char *new)
{
	
	int       retval;
	unsigned char uid;

	struct fcb *fc1;
	struct fcb *fc2;
	
	fc1=buff;
	fc2=(buff+16);

	uid = getuid();

	if ( setfcb(fc1,old) ) 
	return 0;

	if ( setfcb(fc2,new) )
	return 0;
	
	setuid(fc2->uid);
	
    bdos(CPM_DEL,fc2);
    retval = bdos(CPM_REN,fc1);

    setuid(uid);

    return retval;
}
