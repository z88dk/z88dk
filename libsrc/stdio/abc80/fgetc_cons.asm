;
;	ABC80 Routines
;
;	getkey() Wait for keypress
;
;	Maj 2000 - Stefano Bodrato
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
