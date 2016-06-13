/*
 *      Part of the library for fcntlt
 *
 *      int open(char *name,int access, mode_t mode)
 *
 *      djm 27/4/99
 *
 *      Access is either
 *
 *      O_RDONLY = 0
 *      O_WRONLY = 1    Starts afresh?!?!?
 *      O_APPEND = 256
 *
 *      All others are ignored(!)
 *
 * -----
 * $Id: open.c,v 1.2 2016-06-13 19:55:46 dom Exp $
 */


#include <fcntl.h>      /* Or is it unistd.h, who knows! */
#include "cpcfcntl.h"

int open(char *name, int flags, mode_t mode)
{
	switch ( flags ) {
	case O_RDONLY:
		if ( cpcfile.in_used )
			return -1;
		if ( cpc_openin(name,strlen(name),cpcfile.in_buf) ) {
			cpcfile.in_used = 1;
			return 0;	/* File descriptor 0 is read */
		}
		return -1; 		/* Other wise just error */
	case O_WRONLY:
		if ( cpcfile.out_used )
			return -1;
		if ( cpc_openout(name,strlen(name),cpcfile.out_buf) ) {
			cpcfile.out_used = 1;
			return 1;	/* File descriptor 1 is write */
		}
		return	-1;		/* Otherwise just error */
	}
	return	-1;			/* No other modes supported */
}
