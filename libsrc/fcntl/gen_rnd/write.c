/*
 *      Part of the library for fcntl
 *
 *      size_t write(int fd,void *ptr, size_t len)
 *
 * -----
 * $Id: write.c,v 1.2 2014-01-20 09:15:31 stefano Exp $
 */


#include <sys/types.h>
#include <fcntl.h>


size_t write(int fd, void *ptr, size_t len)
{
	int	i;

//    if ( fd >= MAXFILE )
//	return -1;

	for ( i = 0; i < len ; i++ ) {
		if ( writebyte(fd,ptr[i]) == -1 ) {
			return i;
		}
	}

	return i;
}
