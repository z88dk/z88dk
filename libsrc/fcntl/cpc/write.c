/*
 *      Part of the library for fcntl
 *
 *      size_t write(int fd,void *ptr, size_t len)
 *
 * -----
 * $Id: write.c,v 1.1 2003-09-12 16:30:43 dom Exp $
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
