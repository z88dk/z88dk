/*
 *      Part of the library for fcntl
 *
 *      int open(char *name,int access, mode_t mode)
 *
 *      Access (flags) is either
 *
 *      O_RDONLY = 0
 *      O_WRONLY = 1  
 *
 *      All others are ignored(!) - i.e. mode is ignored
 *
 *      The CPC only supports one file for reading and one file writing
 *      at a time
 *
 * -----
 * $Id: open_z88.c,v 1.1 2003-09-12 16:30:43 dom Exp $
 */


#include <fcntl.h>  
#include <string.h>
#include "cpcfcntl.h"



int open_z88(far char *name, int flags, mode_t mode, char *buf, size_t len)
{
	/* Copy the name across */
	strncpy(buf,name,len);
	buf[len-1] = 0;

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
