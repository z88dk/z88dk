/*
 *      Part of the library for fcntl
 *
 *      int open(char *name,int access, mode_t mode)
 *
 *      djm 27/4/99
 *
 *      Access is either
 *       
 *      Flags is one of: O_RDONLY, O_WRONLY, O_RDWR
 *      Or'd with any of: O_CREAT, O_TRUNC, O_APPEND
 *
 *      All others are ignored(!) - i.e. mode is ignored
 *
 *	djm 24/3/2000 - Takes a buffer for expanded filename
 *
 * -----
 * $Id: open_z88.c,v 1.2 2013-03-03 23:51:10 pauloscustodio Exp $
 */


#include <fcntl.h>      /* Or is it unistd.h, who knows! */

int open_z88(far char *name, int flags, mode_t mode, char *buf, size_t len)
{
#asm
        INCLUDE "fileio.def"
        
        ld      ix,0
        add     ix,sp
        ld      l,(ix+10)        ;lower 16 of filename
        ld      h,(ix+11)
	ld	e,(ix+4)
	ld	d,(ix+5)
	ld	c,(ix+2)
	ld	b,(ix+3)
; Copy the filename across
.open_loop
	ld	a,b
	or	c
	jr	z,open_loopexit
	ld	a,(hl)
	ld	(de),a
	and	a
	jr	z,open_loopexit
	inc	hl
	inc	de
	dec	bc
	jr	open_loop
.open_loopexit
	ld	l,(ix+10)
	ld	h,(ix+11)
	ld	a,(ix+8)
	ld	c,1
	and	a		;O_RDONLY
	jr	z,open_forreal
	ld	c,2
	dec	a		;O_WRONLY
	jr	z,open_forreal
	ld	c,0
	dec	a		;O_RDWR
.open_forreal
	ld	a,c
	ld	c,$11		;OPEN
	rst	$10
	ld	hl,-1
	ret	c
	ld	l,a
	ld	h,0
#endasm
}

