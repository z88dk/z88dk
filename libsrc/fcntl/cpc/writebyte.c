/*
 *      Low level reading routines for CPC
 *
 *      writebyte(int fd, int c) - Read byte from file
 *
 *
 * -----
 * $Id: writebyte.c,v 1.1 2003-09-12 16:30:43 dom Exp $
 */


#include <stdio.h>
#include <fcntl.h>



int writebyte(int fd, int byte)
{
	if ( fd != 1 )		/* Check to see if this is the write file */
		return EOF;
#asm
        INCLUDE "#cpcfirm.def"
	pop	bc
	pop	hl	;byte
	pop	de	;file handle (ignore it)
	push	de
	push	hl
	push	bc
	ld	a,l
	push	af
	call	cas_out_char
	pop	af
	ld	l,a
	ld	h,0
	ret	c	;was written ok
	ld	hl,EOF
#endasm
}

        
