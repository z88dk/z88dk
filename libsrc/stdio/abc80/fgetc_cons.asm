;
;	ABC80 Routines
;
;	getkey() Wait for keypress
;
;	Maj 2000 - Stefano Bodrato
;
;
;	$Id: fgetc_cons.asm,v 1.2 2001-04-13 14:13:59 stefano Exp $
;

	XLIB	fgetc_cons

.fgetc_cons
	in	a,(56)
	bit	7,a
	jr	nz,fgetc_cons

.wkey
	in	a,(56)
	bit	7,a
	jr	z,wkey

	sub	128

	ld	l,a
	ld	h,0
	ret
