/*
 *	Sprinter fcntl library
 *
 *      writebyte(int fd, int c) - Read byte from file
 *
 * -----
 * $Id: writebyte.c,v 1.3 2016-03-13 18:14:13 dom Exp $
 */


#include <stdio.h>
#include <fcntl.h>



int writebyte(int fd, int byte)
{
#asm
	push	ix	
        ld      ix,4
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
	pop	ix
	ret	c		;error!
	ld	a,(de)		;success, return with value written
	ld	l,a
	ld	h,0
#endasm
}

        
