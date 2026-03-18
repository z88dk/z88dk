/*
 *  Close a file
 * 
 *  27/1/2002 - djm
 *  HDOS version: Stefano, 2026
 *
 *  $Id: close.c $
 */



#include <fcntl.h>
#include <arch/hdos.h>


int close(int fd)
{
    struct fcb *fc;

    fc = (struct fcb *) fd; 

    if ( fc->use < U_CON ) {
        hdos_cache_flush(fc);
		(hdos_close (fc->ch));  /* Open error */
    }
    fc->use = 0;
    return 0;
}
