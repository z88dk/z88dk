;
;	Mattel AQUARIUS Routines
;
;	getkey() Wait for keypress
;
;	Dec 2001 - Stefano Bodrato
;
;
;	$Id: fgetc_cons.asm,v 1.4 2016-06-12 17:07:43 dom Exp $
;

	SECTION code_clib
	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons

INCHRH	 equ	$1E7E
ext_call equ	$2103

.fgetc_cons
._fgetc_cons
	push	ix
.wkeyrelease
	ld	iy, INCHRH
	call	ext_call
	and	a
	jr	nz,wkeyrelease

.wkey
	ld	iy, INCHRH
	call	ext_call
	and	a
	jr	z,wkey

IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	a,10
.not_return
ENDIF

	ld	l,a
	ld	h,0
	pop	ix
	ret
