/*
 *      Part of the library for fcntlt
 *
 *      int creat(char *name,mode_t mode)
 *
 *      djm 27/4/99
 *
 * -----
 * $Id: creat.c,v 1.1 2002-10-03 20:07:19 dom Exp $
 */


#include <fcntl.h>      /* Or is it unistd.h, who knows! */

int creat(far char *name, mode_t mode)
{
#asm
        ld      ix,0
        add     ix,sp
        ld      l,(ix+4)        ;lower 16 of filename
        ld      h,(ix+5)
	xor	a		;normal file
	ld	c,$0b		;CREAT NEW FILE
	rst	$10
	ld	hl,-1
	ret	c
	ld	a,l
	ld	h,0
#endasm
}

