/*
 *	Parse a filename segment
 *
 *	djm 22/3/2000
 */

#include <z88.h>

int parseseg(far char *seg, far char **end)
{
/* NB far char * is 3 bytes, far char ** is two */
#asm
	INCLUDE	"fileio.def"
	ld	ix,0
	add	ix,sp
	ld	l,(ix+4)	;seg
	ld	h,(ix+5)
	ld	b,(ix+6)
	call_oz(gn_pfs)
	ld	hl,-1
	ret	c
	ex	af,af		;keep it safe
	ex	de,hl
	ld	l,(ix+2)	;**end (i.e. address of &end)
	ld	h,(ix+3)
	ld	a,l
	or	l
	jr	z,getout
	ld	(hl),e		;keep end
	inc	hl
	ld	(hl),d
	inc	hl
	ld	(hl),b
.getout
	ex	af,af		;get it back
	ld	l,a
	ld	h,0
#endasm
}






