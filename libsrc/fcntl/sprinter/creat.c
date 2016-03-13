/*
 *      Part of the library for fcntlt
 *
 *      int creat(char *name,mode_t mode)
 *
 *      djm 27/4/99
 *
 * -----
 * $Id: creat.c,v 1.2 2016-03-13 18:14:13 dom Exp $
 */


#include <fcntl.h>      /* Or is it unistd.h, who knows! */

int creat(far char *name, mode_t mode)
{
#asm
	push	ix
        ld      ix,2
        add     ix,sp
        ld      l,(ix+4)        ;lower 16 of filename
        ld      h,(ix+5)
	xor	a		;normal file
	ld	c,$0b		;CREAT NEW FILE
	rst	$10
	ld	hl,-1
	pop	ix
	ret	c
	ld	a,l
	ld	h,0
#endasm
}

