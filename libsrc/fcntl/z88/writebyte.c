/*
 *      Low level reading routines for Small C+ Z88
 *
 *      writebyte(int fd, int c) - Read byte from file
 *
 * 	djm 4/5/99
 *
 * -----
 * $Id: writebyte.c,v 1.3 2003-10-01 20:01:07 dom Exp $
 */


#include <stdio.h>
#include <fcntl.h>



int writebyte(int fd, int byte)
{
#asm
        INCLUDE "#fileio.def"
	pop	bc
	pop	hl	;byte
	pop	ix	;file handle
	push	ix
	push	hl
	push	bc
	ld	a,l

	push	af
        call_oz(os_pb)
	pop	af
        ld      hl,-1	;EOF
        ret     c
        ld      l,a
        ld      h,0
#endasm
}

        
