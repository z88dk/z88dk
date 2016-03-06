/*
 *
 *      readbyte(fd) - Read byte from file
 *
 *      Preserve tabs!!
 *
 * -----
 * $Id: readbyte.c,v 1.5 2016-03-06 20:36:13 dom Exp $
 */


#include <stdio.h>
#include <fcntl.h>



int __FASTCALL__ readbyte(int fd)
{
#asm
        INCLUDE "fileio.def"

        push    ix
        push    hl
	pop     ix  
	call_oz(os_gb)
	ld      hl,-1	;EOF
	ret     c
	ld      l,a
	ld      h,0
        pop     ix
#endasm
}

        
