/*
 *      Low level reading routines for Small C+ Z88
 *
 *      writebyte(int fd, int c) - Read byte from file
 *
 * 	djm 4/5/99
 *
 * -----
 * $Id: writebyte.c,v 1.4 2013-03-03 23:51:11 pauloscustodio Exp $
 */


#include <stdio.h>
#include <fcntl.h>



int writebyte(int fd, int byte)
{
#asm
        INCLUDE "fileio.def"
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

        
