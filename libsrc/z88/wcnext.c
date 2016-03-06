/*
 *	Read the next match for wildcard string
 *
 *	djm 22/2/2000
 */

#include <z88.h>

int wcnext(wild_t handle, void *buffer, size_t len, wildcard_t *wst)
{
#asm
	INCLUDE	"fileio.def"
	push	ix
	ld	ix,2
	add	ix,sp
	ld	c,(ix+4)	;len
	ld	e,(ix+6)	;buffer
	ld	d,(ix+7)
	ld	l,(ix+8)	;handle
	ld	h,(ix+9)
	push	ix		;keep ix safe
	push	hl
	pop	ix
	call_oz(gn_wfn)	
	pop	ix
	ld	hl,-1		;EOF
	jr	c,wcnext_exit	;error
	ex	af,af		;keep af safe
	ld	l,(ix+2)
	ld	h,(ix+3)
	ld	a,l
	or	l
	jr	z,wcnext_exit	;okay! no buffer
	ex	af,af		;get it back
	push	hl
	ld	(hl),e		;last char of explicit name
	inc	hl
	ld	(hl),d
	inc	hl
	ld	(hl),b		;segments in explicit filename
	inc	hl
	ld	(hl),c		;chars in explicit filename
	inc	hl
	ld	(hl),a		;DOR type
	ld	hl,0		;o error
wcnext_exit:
	pop	ix
#endasm
}






	
