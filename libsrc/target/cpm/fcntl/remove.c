/*
 *   Remove a file from the system
 *
 *   Based on Hitech C as usual
 *
 *   $Id: remove.c,v 1.2 2012-06-15 07:46:52 stefano Exp $
 */

#include <cpm.h>
#include <fcntl.h>
#include <stdio.h>


int remove(char *name)
{
    struct fcb fc;

    int       retval;
    unsigned char uid;

    if ( setfcb(&fc,name) ) 
	return 0;

	uid = swapuid(fc.uid);

    retval = bdos(CPM_DEL,&fc);

    swapuid(uid);
    return retval;
}
