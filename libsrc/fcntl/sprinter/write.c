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
 * $Id: write.c,v 1.2 2013-03-03 23:51:10 pauloscustodio Exp $
 */


#include <sys/types.h>
#include <fcntl.h>


size_t write(int fd, void *ptr, size_t len)
{
#asm
        INCLUDE         "fileio.def"

        ld      ix,2
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
	ret	nc
	ld	hl,-1
#endasm
}
