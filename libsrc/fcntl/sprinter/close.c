/*
 *      Part of the library for fcntlt
 *
 *      int close(int fd)
 *
 *      djm 27/4/99
 *
 *      Close a file descriptor, pretty well identical to
 *      fclose from the other stuff
 *
 * -----
 * $Id: close.c,v 1.1 2002-10-03 20:07:19 dom Exp $
 */


#include <fcntl.h>


int close(int fd)
{
#asm
        pop     bc
        pop     hl
        push    hl
        push    bc
	ld	a,l
	ld	c,$12	;CLOSE
	rst	$10
	ld	hl,0
	ret	nc
	dec	hl
#endasm
}
