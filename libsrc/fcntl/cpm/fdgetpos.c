/*
 *	int fdgetpos(int fd, fpos_t *posn) __smallc;
 *
 *
 *	$Id: fdgetpos.c $
*/

#include <fcntl.h>
#include <stdio.h>
#include <cpm.h>

int fdgetpos(int fd, fpos_t *posn)
{
	struct	fcb *fc;

	if(fd >= MAXFILE)
		return -1;
	
	fc = &_fcb[fd];
	*posn = (fpos_t)fc->rwptr;
	
	return 0;
}

