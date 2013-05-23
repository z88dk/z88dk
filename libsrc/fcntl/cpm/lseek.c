/*
 *	long lseek(int fd, long posn, int whence)
 *
 *	0	SEEK_SET from start of file
 *	1	SEEK_CUR from current position
 *	2	SEEK_END from end of file (always -ve)
 *
 *	$Id: lseek.c,v 1.4 2013-05-23 16:27:04 stefano Exp $
*/

#include <fcntl.h>
#include <stdio.h>
#include <cpm.h>

long lseek(int fd,long posn, int whence)
{
	struct	fcb *fc;
	long	pos;
	char buffer[1];

	if(fd >= MAXFILE)
		return -1;
	fc = &_fcb[fd];
	switch(whence) {

	default:
		pos = posn;
		break;

	case 1:
		pos = fc->rwptr + posn;
		break;

	case 2:
		while (read(fd,buffer,1) != EOF) {
			if (buffer[0]==0x1a) break;
		}
		pos = fc->rwptr-1;
		break;
	}
	if(pos >= 0L) {
		fc->rwptr = pos;
		return fc->rwptr;
	}
	return -1;
}

