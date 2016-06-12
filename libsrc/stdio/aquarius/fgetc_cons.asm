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

.fgetc_cons
._fgetc_cons
	call	$1e80
	and	a
	jr	nz,fgetc_cons

.wkey
	call	$1e80
	and	a
	jr	z,wkey

	ld	l,a
	ld	h,0
	ret
