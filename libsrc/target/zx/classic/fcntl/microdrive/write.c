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
#include <arch/zx/zxinterface1.h>


ssize_t write(int fd, void *ptr, size_t len)
{
	int	i;
	struct M_CHAN *if1_file;
	
	if1_file = (void *) fd;

	if ( if1_file->base.id_char != 0xCD ) {	/* It's not a Microdrive file */
		return -1;
	}

	for ( i = 0; i < len ; i++ ) {
		if ( writebyte(fd,ptr[i]) == -1 ) {
			return i;
		}
	}

	return i;
}
