/*
 * Printf style formatting. (Borrowed from MicroEmacs by Dave Conroy.) 
 * A lot smaller than the full fledged printf.
 *
 * Liberated once more and inserted into Small C+ 29/4/99 djm
 *	
 *	$Id: minifprintf.c,v 1.2 2001-04-13 14:14:00 stefano Exp $
 */

#define ANSI_STDIO

#include <stdio.h>


/*
 * Cheating somewhat, this will cause a barf in the compiler...bigtime..
 * nevermind...
 */


void minifprintf(FILE *fp, char *fmt,...)
{
        int  *ct;
        ct= (getarg()*2)+&fmt-4;

        minivfprintf(*ct,*(ct-1),ct-2);
}

