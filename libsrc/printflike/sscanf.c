/*
 * Minix source: src/commands/simple/uud.c
 *
 * Printf style formatting. (Borrowed from MicroEmacs by Dave Conroy.) 
 * A lot smaller than the full fledged printf.
 *
 * Liberated once more and inserted into Small C+ 29/4/99 djm
 *
 * This routine is quite long also, hopefully it'll become a lot
 * shorter with the new io routines
 *
 * New I/O version, we fake up a file channel which is in fact
 * a string djm 1/4/2000
 */

#define ANSI_STDIO

#include <stdio.h>



int sscanf(char *str,char *fmt,...)
{
	FILE	temp;
	int  num;
        int  *ct;
        ct= (getarg()*2)+&fmt-4;

	temp.desc.ptr=(void *)(*ct);
	temp.flags=_IOREAD|_IOSTRING|_IOUSE;
	temp.ungetc = 0;

        return (vfscanf(temp,(unsigned char *)(*(ct-1)),ct-2));
}

