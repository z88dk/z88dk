/*
 *      Part of the library for fcntlt
 *
 *      int close(int fd)
 *
 * -----
 * $Id: close.c,v 1.1 2003-09-12 16:30:43 dom Exp $
 */


#include <fcntl.h>
#include "cpcfcntl.h"

/* Place cpcfile to avoid weird reference problems within z80asm */
cpc_fd  cpcfile;

int close(int fd)
{
	if ( fd == 0 ) {	/* Reading */
		if ( cpc_closein() ) {
			cpcfile.in_used = 0;
			return 0;
		}
	} else if ( fd == 1 ) { /* Writing */
		if ( cpc_closeout() ) {
			cpcfile.out_used = 0;
			return 0;
		}
	}

	return -1;	/* Unknown file/couldn't close */
}
