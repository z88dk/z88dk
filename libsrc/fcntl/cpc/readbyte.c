/*
 *      Low level reading routines for CPC
 *
 *      writebyte(int fd, int c) - Read byte from file
 *
 *
 * -----
 * $Id: readbyte.c,v 1.1 2003-09-12 16:30:43 dom Exp $
 */


#include <stdio.h>
#include <fcntl.h>



int __FASTCALL__ readbyte(int fd)
{
	if ( fd != 0 )		/* Check to see if this is the read file */
		return EOF;
#asm
        INCLUDE "#cpcfirm.def"
	call	cas_in_char
	ccf
	ld	l,a
	ld	h,0
	jr	nc,read_ok
	ld	hl,EOF
.read_ok	; Need this label since this function is __FASTCALL__
#endasm
}

        
