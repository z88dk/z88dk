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
 * $Id: lseek.c,v 1.1 2002-10-03 20:07:20 dom Exp $
 */


#include <fcntl.h>      /* Or is it unistd.h, who knows! */

long lseek(int fd, long posn, int whence)
{
#asm
        INCLUDE "#fileio.def"
        
        ld      ix,0    
        add     ix,sp
        ld      b,(ix+2)        ;whence
	ld	l,(ix+4)	;file position
	ld	h,(ix+5)
	ld	e,(ix+6)	;needs to go into ix at some point
	ld	d,(ix+7)
	ld	a,(ix+9)	;fd
	push	de
	pop	ix
	ld	c,$15		;MOVE_FP
	rst	$10
	jr	nc,lseek_ret
	ld	hl,-1
	ld	de,-1
	ret
.lseek_ret
	push	ix
	pop	de
#endasm
}

