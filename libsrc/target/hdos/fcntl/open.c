/*
 *      Part of the library for fcntlt
 *
 *      int open(char *name,int access, mode_t mode)
 *
 *      djm 27/4/99
 *      HDOS version: Stefano, 2026
 *
 *      Flags are either:
 *
 *      O_RDONLY = 0
 *      O_WRONLY = 1   
 *      O_RDWR   = 2    
 *
 *      | with:
 *      O_APPEND = 256
 *      O_TRUNC  = 512
 *      O_CREAT  = 1024
 *
 * -----
 * $Id: open.c $
 */

#include <arch/hdos.h>
#include <stdio.h>
#include <fcntl.h>      /* Or is it unistd.h, who knows! */



int open(char *name, int flags, mode_t mode)
{
    struct fcb *fc;

    if ( ( fc = getfcb() ) == NULL ) {
        return -1;
    }

    if ( setfcb(fc,name) == 0 ) {  /* We had a real file, not a device */

        if (flags == O_TRUNC)
            if (hdos_delete (name))
                if ( (flags & O_CREAT) == 0) {
                    // Truncating a non-existing file (ENOENT)
                    clearfcb(fc);
                    return(-1);
                }

        switch ( flags & 0xff ) {
            case O_RDONLY:
                if (hdos_open_rd (name, fc->ch))
                {
                    // FILE NOT FOUND
                    clearfcb(fc);
                    return(-1);
                }
                // fc->use = U_READ;   // Probably not necessary
                break;

            // We get here also to 'APPEND' to a non-existing file
            case O_WRONLY:
            case O_RDWR:

                if (hdos_open_upd (name, fc->ch)) {
                    if (hdos_open_wr (name, fc->ch))
                    {
                        // FILE CREATE ERROR
                        clearfcb(fc);
                        return(-1);
                    }
                }
                break;

        }
        
        // TODO: position the file ptr for O_APPEND

        return (int)fc;

    } else return -1;
}
