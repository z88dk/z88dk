/*
 *	long fdtell(int fd)
 *
 *	$Id: fdtell.c $
*/

#include <fcntl.h>
#include <stdio.h>
#include <cpm.h>


long fdtell(int fd)
{
	struct	fcb *fc;

	if(fd >= MAXFILE)
		return -1;
	
	fc = &_fcb[fd];
	
	return (fc->rwptr);
}

