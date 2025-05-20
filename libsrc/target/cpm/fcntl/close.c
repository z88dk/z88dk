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

    fc = (struct fcb *) fd; 

    uid = swapuid(fc->uid);      /* Set it to that of the file */
    if ( fc->use < U_CON ) {
        cpm_cache_flush(fc);
        bdos(CPM_CLS,fc);
    }
    fc->use = 0;
    swapuid(uid);
    return 0;
}
