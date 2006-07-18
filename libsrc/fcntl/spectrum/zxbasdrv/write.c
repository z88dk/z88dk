/*
 *      Part of the library for fcntl
 *
 *      size_t write(int fd,void *ptr, size_t len)
 *
 * -----
 * $Id: write.c,v 1.1 2006-07-18 21:02:54 stefano Exp $
 */


#include <sys/types.h>
#include <fcntl.h>


size_t write(int fd, void *ptr, size_t len)
{
	int	i;

	if ( fd != 1 ) {	/* It's not the write descriptor */
		return -1;
	}

	for ( i = 0; i < len ; i++ ) {
		if ( writebyte(fd,ptr[i]) == -1 ) {
			return i;
		}
	}

	return i;
}
