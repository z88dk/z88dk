;
;	Mattel AQUARIUS Routines
;
;	getkey() Wait for keypress
;
;	Dec 2001 - Stefano Bodrato
;
;
;	$Id: fgetc_cons.asm,v 1.1 2001-12-24 13:23:08 stefano Exp $
;

	XLIB	fgetc_cons

.fgetc_cons
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
