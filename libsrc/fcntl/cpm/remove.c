/*
 *   Remove a file from the system
 *
 *   Based on Hitech C as usual
 *
 *   $Id: remove.c,v 1.1 2002-01-27 21:28:48 dom Exp $
 */

#include <cpm.h>
#include <fcntl.h>
#include <stdio.h>


int remove(char *name)
{
    struct fcb  fc;
    int       retval;
    unsigned char uid,pad;

    if ( setfcb(fc,name) ) 
	return 0;

    uid = getuid();
    setuid(fc.uid);
    retval = bdos(CPM_DEL,&fc);
    setuid(uid);
    return retval;
}
