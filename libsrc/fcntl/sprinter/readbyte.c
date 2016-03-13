/*
 *      Sprinter fcntl library
 *
 *      readbyte(fd) - Read byte from file
 *
 * -----
 * $Id: readbyte.c,v 1.3 2016-03-13 18:14:13 dom Exp $
 */


#include <stdio.h>
#include <fcntl.h>



int __FASTCALL__ readbyte(int fd)
{
#asm
	push	ix	;save callers
	ex	de,hl	;de = fd
	push	de	;make somespace
	ld	hl,0
	add	hl,sp
	ld	a,e	;fd now in e
	ld	de,1	;length to read
	ld	c,$13   ;READ
	rst	$10
	pop	de	;e holds the read value
	ld	hl,-1
	pop	ix
	ret	c	;error, return EOF
	ld	l,e
	ld	h,0
#endasm
}

        
