/*
 *      Sprinter fcntl library
 *
 *      readbyte(fd) - Read byte from file
 *
 * -----
 * $Id: readbyte.c,v 1.2 2003-09-10 20:22:52 dom Exp $
 */


#include <stdio.h>
#include <fcntl.h>



int __FASTCALL__ readbyte(int fd)
{
#asm
	pop	de	;get fd
	push	de	;restore fd
	push	de	;make somespace
	ld	hl,0
	add	hl,sp
	ld	a,e	;fd now in e
	ld	de,1	;length to read
	ld	c,$13   ;READ
	rst	$10
	pop	de	;e holds the read value
	ld	hl,-1
	ret	c	;error, return EOF
	ld	l,e
	ld	h,0
#endasm
}

        
