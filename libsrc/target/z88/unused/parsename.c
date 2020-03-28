/*
 *	Parse a filename
 *
 *	djm 22/3/2000
 */

#include <z88.h>

int parsefile(far char *name, wildcard_t *st)
{
#asm
	INCLUDE	"fileio.def"
	ld	ix,0
	add	ix,sp
	ld	e,(ix+2)	;st
	ld	d,(ix+3)
	ld	l,(ix+4)	;name
	ld	h,(ix+5)
	ld	b,(ix+6)
	call_oz(gn_prs)
	ld	hl,-1
	ret	c
	ex	de,hl
	ex	af,af		;keep flags safe
	ld	a,l
	or	l
	jr	z,getout
	ld	(hl),0		;endptr
	inc	hl
	ld	(hl),0
	inc	hl
	ld	(hl),b		;segments
	inc	hl
	ld	(hl),c		;length
	inc	hl
	ld	(hl),0		;DOR
.getout
	ex	af,af
	ld	l,a
	ld	h,0
#endasm
}


