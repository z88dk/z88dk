/*
 *      Part of the library for fcntl
 *
 *      size_t write(int fd,void *ptr, size_t len)
 *
 *      djm 27/4/99
 *
 *      Close a file descriptor, pretty well identical to
 *      fclose from the other stuff
 *
 * -----
 * $Id: write.c,v 1.3 2016-03-13 18:14:13 dom Exp $
 */


#include <sys/types.h>
#include <fcntl.h>


size_t write(int fd, void *ptr, size_t len)
{
#asm
	push	ix
        ld      ix,4
        add     ix,sp
        ld      e,(ix+0)        ;len
        ld      d,(ix+1)
        ld      l,(ix+2)        ;ptr
        ld      h,(ix+3)
        ld      a,(ix+4)        ;fd
	ld	c,$14		;WRITE
	; Making the same assumptions as read()
	rst	$10
	ex	de,hl
	pop	ix
	ret	nc
	ld	hl,-1
#endasm
}
