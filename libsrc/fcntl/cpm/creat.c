/*
 *  Create a file
 * 
 *  27/1/2002 - djm
 *
 *  Based on Hitech C library (as usual)
 *
 *  $Id: creat.c,v 1.1 2002-01-27 21:28:48 dom Exp $
 */

#include <cpm.h>
#include <stdio.h>
#include <fcntl.h>


int creat(far char *nam, mode_t mode)
{
    struct fcb *fc;
    char       *name;
    int         fd;
    unsigned char pad,uid;

    name = nam;

    if ( ( fc = getfcb() ) == NULL )
	return -1;

    uid = getuid();

    if ( setfcb(fc,name) == 0 ) {
	remove(name);
	setuid(fc->uid);
	if ( bdos(CPM_MAKE,fc) == -1 ) {
	    setuid(uid);
	    fc->use = 0;
	    return -1;
	}
	setuid(uid);
	fc->use = U_WRITE;
    }
    
    fd = fc - &_fcb[0];
    return fd;
}


