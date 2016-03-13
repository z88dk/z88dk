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
 * $Id: close.c,v 1.2 2016-03-13 18:14:13 dom Exp $
 */


#include <fcntl.h>


int close(int fd)
{
#asm
        pop     bc
        pop     hl
        push    hl
        push    bc
	push	ix
	ld	a,l
	ld	c,$12	;CLOSE
	rst	$10
	pop	ix
	ld	hl,0
	ret	nc
	dec	hl
#endasm
}
