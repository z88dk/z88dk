/*
 *      Part of the library for fcntlt
 *
 *      char *getcwd(char *buf, size_t size);
 *
 *      djm 27/4/99
 *
 *      Close a file descriptor, pretty well identical to
 *      fclose from the other stuff
 *
 * -----
 * $Id: getcwd.c,v 1.1 2002-11-20 20:28:44 dom Exp $
 */


#include <sys/types.h>
#include <fcntl.h>
#include <stdio.h>


char *getcwd(char *buf,size_t size)
{
	static	char   mybuf[256];

	if ( ( getwd(mybuf) ) == NULL ) {
		return NULL;
	}

	/* Extension to POSIX - incompatible with glibc */
	if ( buf == NULL )
		return mybuf;

	strncpy(buf,mybuf,size-1);
	mybuf[size-1] = 0;
	return	buf;
}
