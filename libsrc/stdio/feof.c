/*
 *	Check for end of file
 *
 *	Return 1 = EOF 0 = not eof
 *
 *	djm 1/4/2000
 */

#define ANSI_STDIO

#include <stdio.h>

int feof(FILE *fp)
{
	return (fp->flags&_IOEOF ? 1 : 0 );
}



