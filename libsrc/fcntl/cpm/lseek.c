/*
 *	long lseek(int fd, long posn, int whence)
 *
 *	0	SEEK_SET from start of file
 *	1	SEEK_CUR from current position
 *	2	SEEK_END from end of file (always -ve)
 *
 *	$Id: lseek.c,v 1.2 2009-01-12 12:27:11 stefano Exp $
*/

#include <fcntl.h>
#include <stdio.h>
#include <cpm.h>


long
_fsize(fd)
uchar	fd;
{
	struct	fcb *fc;
	long	tmp;
	int	luid;

	if(fd >= MAXFILE)
		return -1;
	
	fc = &_fcb[fd];
	
	luid = getuid();
	setuid(fc->uid);
	bdos(CPM_CFS, fc);
	setuid(luid);
	
	tmp = (long)fc->ranrec[0] + ((long)fc->ranrec[1] << 8) + ((long)fc->ranrec[2] << 16);
	tmp *= SECSIZE;
	if(tmp > fc->rwptr)
		return tmp;
	return fc->rwptr;
}


long lseek(int fd,long posn, int whence)
{
	struct	fcb *fc;
	long	pos;

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
		pos = posn + _fsize(fd);
		break;
	}
	if(pos >= 0) {
		fc->rwptr = pos;
		return fc->rwptr;
	}
	return -1;
}

