/*
 *      Part of the library for fcntlt
 *
 *      size_t read(int fd,void *ptr, size_t len)
 *
 *      djm 27/4/99
 *
 *      Close a file descriptor, pretty well identical to
 *      fclose from the other stuff
 *
 * -----
 * $Id: read.c,v 1.2 2016-03-13 18:14:13 dom Exp $
 */


#include <sys/types.h>
#include <fcntl.h>


size_t read(int fd, void *ptr, size_t len)
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
	; Its not entirely clear what happens in the system call (estex.cpp
	; isnt much help), we will assume that de always contains the
	; number of bytes read
	ld	c,$13		;READ
	rst	$10
	pop	ix
	ex	de,hl
	ret	nc		;we did some reading
	ld	hl,-1		;error
#endasm
}
