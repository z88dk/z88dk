/*
 *  Close a file
 * 
 *  27/1/2002 - djm
 *
 *  $Id: close.c,v 1.1 2002-01-27 21:28:48 dom Exp $
 */



#include <fcntl.h>
#include <cpm.h>


int close(int fd)
{
    struct fcb *fc;
    unsigned char uid;

    if ( fd >= MAXFILE )
	return -1;

    fc = &_fcb[fd];
    uid = getuid();       /* Get our uid, keep safe */
    setuid(fc->uid);      /* Set it to that of the file */
    if ( fc->use )
	bdos(CPM_CLS,fc);
    fc->use = 0;
    setuid(uid);
    return 0;
}
