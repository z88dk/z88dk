/*
 *	long fdtell(int fd)
 *
 *	$Id: fdtell.c,v 1.1 2009-01-12 12:27:11 stefano Exp $
*/

#include <fcntl.h>
#include <stdio.h>
#include <cpm.h>


long fdtell(int fd)
{
	return lseek(fd, 0L, SEEK_CUR);
}

