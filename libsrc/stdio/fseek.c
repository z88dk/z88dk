/*
 *	Get the position of a file
 *
 *	long ftell(FILE *fp)
 *
 *	Calls some machine dependent routine to do the dirty work
 *
 *	djm 1/4/2000
 */

#define ANSI_STDIO

#ifdef Z80
#define STDIO_ASM
#endif

#include <stdio.h>
#include <fcntl.h>

int fseek(FILE *fp, fpos_t posn, int whence)
{
	if ( fp->flags&_IOUSE && fchkstd(fp)== 0 ) {
		if (lseek(fp->fd,posn,whence) != -1L )
			return 0;
	}
	return 1;
}


