;
;	ABC80 Routines
;
;	getk() Read key status
;
;	Maj 2000 - Stefano Bodrato
;


	XLIB	getk

.getk
	in	a,(56)
	bit	7,a
	jr	z,nokey

	sub	128
	jr	keyread

.nokey	xor	a

.keyread
	ld	l,a
	ld	h,0
	ret
