/*
 *	Sprinter fcntl library
 *
 *      writebyte(int fd, int c) - Read byte from file
 *
 * -----
 * $Id: writebyte.c,v 1.2 2003-09-10 20:22:52 dom Exp $
 */


#include <stdio.h>
#include <fcntl.h>



int writebyte(int fd, int byte)
{
#asm
        ld      ix,2
        add     ix,sp
        ld      a,(ix+2)        ;fd
	push	ix
	pop	hl
	ld	de,1
	ld	c,$14		;WRITE
	push	hl
	rst	$10
	pop	hl
	ld	hl,-1
	pop	de
	ret	c		;error!
	ld	a,(de)		;success, return with value written
	ld	l,a
	ld	h,0
#endasm
}

        
