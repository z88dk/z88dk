/*
 *      Part of the library for fcntlt
 *
 *      long lseek(int fd,long posn, int whence)
 *
 *      djm 27/4/99
 *
 *      whence=
 *
 *   0  SEEK_SET from start of file
 *   1  SEEK_CUR from current position
 *   2  SEEK_END from end of file (always -ve)
 *
 * -----
 * $Id: lseek.c,v 1.4 2016-03-13 18:14:13 dom Exp $
 */


#include <fcntl.h>      /* Or is it unistd.h, who knows! */

long lseek(int fd, long posn, int whence)
{
#asm
       	push	ix 
        ld      ix,2    
        add     ix,sp
        ld      b,(ix+2)        ;whence
	ld	e,(ix+4)	;file position
	ld	d,(ix+5)
	ld	l,(ix+6)	;needs to go into ix at some point
	ld	h,(ix+7)
	ld	a,(ix+8)	;fd
	push	de
	pop	ix
	ld	c,$15		;MOVE_FP
	rst	$10
	jr	nc,lseek_ret
	pop	ix
	ld	hl,-1
	ld	de,-1
	ret
.lseek_ret
	push	ix
	pop	de
	pop	ix
#endasm
}

