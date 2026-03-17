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
 *      O_TRUNC = 512
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

		if (flags & O_RDONLY) {
		  if (hdos_open_rd (name, fc->ch)) goto open_error;  /* Open error */
		  fc->use = U_READ;
		} else {   // Writing

			if (flags & O_TRUNC)
				if (hdos_delete (name))
					if ( (flags & O_CREAT) == 0) goto open_error;  /* Truncating a non-existing file (ENOENT) */
			
			if (flags & (O_APPEND | O_RDWR)) {
				if (hdos_open_upd (name, fc->ch)) goto open_error;  /* Open error */
				fc->use=U_RDWR;
			} else
				if (hdos_open_wr (name, fc->ch)) goto open_error;  /* Open error */

			if (flags & (O_RDWR))
				fc->use = U_RDWR;
			else
				fc->use = U_WRITE;

		}

        // fc->use = (flags + 1 ) & 0xff;
    }
	
	//  TODO: move to the bottom of the file
    //        using HDOS to verify we are getting EOF, then computing 65535-BC)
	// if (flags & O_APPEND)
	// 	  hdos_posit(fc->ch, 65535);

    fc->mode = mode & _IOTEXT;

    return (int)fc;

open_error:
    clearfcb(fc);
	return -1;

}
