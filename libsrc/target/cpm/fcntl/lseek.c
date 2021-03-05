/*
 *	long lseek(int fd, long posn, int whence)
 *
 *	0	SEEK_SET from start of file
 *	1	SEEK_CUR from current position
 *	2	SEEK_END from end of file (always -ve)
 *
 *	$Id: lseek.c,v 1.6 2013-06-06 08:58:32 stefano Exp $
*/

#include <fcntl.h>
#include <stdio.h>
#include <cpm.h>

long lseek(int fd,long posn, int whence)
{
	struct	fcb *fc;
	long	pos;
	char	buffer;

	if(fd >= MAXFILE)
		return -1L;
	
	fc = &_fcb[fd];
	
	switch(whence) {
	default:
		pos = posn;
		break;
	case 1:
		pos = fc->rwptr + posn;
		break;
	case 2:
		bdos(CPM_CFS,fc);
		pos = (unsigned long) (fc->ranrec[0] + 256 * fc->ranrec[1]) * 128L;
		if (fc->ranrec[2]&1)
			pos += 8388608L;
		if ((fc->mode & _IOTEXT) && (pos > 0)) {
			while ((read(fd,&buffer,1) != -1) && (buffer != __STDIO_EOFMARKER)) {}
			pos = fc->rwptr-1;
		}
		pos = pos + posn;
		break;
	}

	if (pos < 0L)
		return -1L;
	
	fc->rwptr = pos;
	return pos;
	
}
