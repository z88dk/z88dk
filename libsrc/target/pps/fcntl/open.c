/*
 *      Part of the library for fcntlt
 *
 *      int open(char *name,int access, mode_t mode)
 *
 *      djm 3/10/2002
 *
 *      Flags is one of: O_RDONLY, O_WRONLY, O_RDWR
 *      Or'd with any of: O_CREAT, O_TRUNC, O_APPEND
 *
 *      All others are ignored(!)
 *
 * -----
 * $Id: open.c,v 1.2 2016-06-13 19:55:48 dom Exp $
 */


#include <fcntl.h>      /* Or is it unistd.h, who knows! */

int open(char *name, int flags, mode_t mode)
{
#asm
	push	ix
        ld      ix,2
        add     ix,sp
        ld      l,(ix+6)   
        ld      h,(ix+7)
	ld	a,(ix+4)
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
	pop	ix		;restore callers
	ld	hl,-1
	ret	c
	ld	l,a
	ld	h,0
#endasm
}

