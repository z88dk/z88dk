/*
 *      Part of the library for fcntl
 *
 *      size_t write(int fd,void *ptr, size_t len)
 *
 * -----
 * $Id: write.c,v 1.1 2014-01-14 07:48:41 stefano Exp $
 */


#include <sys/types.h>
#include <fcntl.h>

//#include <stdio.h>

size_t write(int fd, void *ptr, size_t len)
{
	int	i;

//    if ( fd >= MAXFILE )
//	return -1;

	for ( i = 0; i < len ; i++ ) {
		//printk("%u",ptr[i]);
		//fputc_cons(i+32);
		if ( writebyte(fd,ptr[i]) == -1 ) {
			return i;
		}
	}

	return i;
}
