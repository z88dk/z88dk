/*
 *      Part of the library for fcntl
 *
 *      size_t write(int fd,void *ptr, size_t len)
 *
 * -----
 * $Id: write.c,v 1.2 2007-06-03 15:13:06 stefano Exp $
 */


#include <sys/types.h>
#include <fcntl.h>


size_t write(int fd, void *ptr, size_t len)
{
	int	i;

	for ( i = 0; i < len ; i++ ) {
		if ( writebyte(fd,ptr[i]) == -1 ) {
			return i;
		}
	}

	return i;
}
