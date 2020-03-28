/*
 *      Part of the library for fcntl
 *
 *      size_t write(int fd,void *ptr, size_t len)
 *
 * -----
 * $Id: write.c $
 */


#include <sys/types.h>
#include <fcntl.h>


ssize_t write(int fd, void *ptr, size_t len)
{
	int	i;

	for ( i = 0; i < len ; i++ ) {
		if ( writebyte(fd,ptr[i]) == -1 ) {
			return i;
		}
	}

	return i;
}
