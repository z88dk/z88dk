/*
 *	long lseek(int fd, long posn, int whence)
 *
 *	Generic version, crap: it is slow and it will work well
 *	only if we are at beginning of file (i.e. file newly opened) !
 *
 *	0	SEEK_SET from start of file
 *	1	SEEK_CUR from current position
 *	2	SEEK_END from end of file (always -ve)
 *
 *	$Id: lseek.c,v 1.1 2009-01-07 18:27:22 stefano Exp $
*/

#include <fcntl.h>
#include <stdio.h>


long lseek(int handle, long posn, int whence)
{
	long	position;
	
	if (whence == SEEK_END) {
		position=0;
		// Move up to end of file
		while (readbyte(handle) != EOF)
			position++;
	}
	else {
		for ( position=0; (position!=posn) && (readbyte(handle) != EOF); position++);
	}
	return (position);
}
