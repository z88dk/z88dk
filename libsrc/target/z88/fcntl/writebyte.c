/*
 *      Low level reading routines for Small C+ Z88
 *
 *      writebyte(int fd, int c) - Read byte from file
 *
 * 	djm 4/5/99
 *
 * -----
 * $Id: writebyte.c,v 1.5 2016-03-06 20:36:13 dom Exp $
 */


#include <stdio.h>
#include <fcntl.h>



int writebyte(int fd, int byte)
{
#asm
        INCLUDE "fileio.def"
	pop	bc
	pop	hl	;byte
	pop	de	;file handle
	push	de
	push	hl
	push	bc

        push    ix
        push    de
        pop     ix
	ld	a,l

	push	af
        call_oz(os_pb)
	pop	af
        pop     ix
        ld      hl,-1	;EOF
        ret     c
        ld      l,a
        ld      h,0
#endasm
}

        
