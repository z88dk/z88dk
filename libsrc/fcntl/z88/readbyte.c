/*
 *      Low level reading routines for Small C+ Z88
 *
 *      readbyte(fd) - Read byte from file
 *
 *      Preserve tabs!!
 */

#include <stdio.h>
#include <fcntl.h>



int __FASTCALL__ readbyte(int fd)
{
#asm
        INCLUDE "#fileio.def"

	pop     ix      ; On entry to FASTCALL function, the parameter
			; is pushed onto the stack        
	call_oz(os_gb)
	ld      hl,EOF
	ret     c
	ld      l,a
	ld      h,0
	push    hl
#endasm
}

        
