/*
 *	Open a package for use by the application
 *
 *	Supply 0 to check package handling is installed
 *
 *	djm 12/1/2000
 */

#include <z88.h>

bool_t QueryPackage(int which, int major,int minor)
{
#pragma asm
	INCLUDE "packages.def"
	call_pkg(pkg_ayt)		;preserves ix
	jr	c,openfail
	ld	hl,6
	add	hl,sp	;points to library number
	ld	a,(hl)
	ld	c,a
	and	a	;0=just check packages
	jr	z,opensuc
;bc holds library, c holds code, so load b with ayt
	ld	b,$2	;ayt
	push	bc	;keep bc for later
	push	bc
	pop	iy
	rst	16	;call package thru iy
	pop	iy	;get bc back into iy
	jr	c,openfail
; Check to see if we need to check the version
; If we or the two together and end up with 0 then we were
; given 0,0 i.e. any will do
	ld	hl,4
	add	hl,sp	
	ld	a,(hl)	;major
	dec	hl
	dec	hl
	or	(hl)	;minor
	jr	z,opensuc	
; Now check the version
	ld	iyh,$0	;inf
	rst	16		;version in de
	ld	hl,4
	add	hl,sp		;points to major required
	ld	a,(hl)
	cp	d
	jr	c,openfail	;major < required
	jr	z,ckminor	;major = required
.opensuc
	ld	hl,1		;success
	and	a
	ret

.ckminor
	dec	hl
	dec	hl		;points to minor required
	ld	a,(hl)
	cp	e		;package minor
	jr	nc,opensuc
	
.openfail
	ld	hl,0
	scf
	
#endasm


}



/* End of file */


