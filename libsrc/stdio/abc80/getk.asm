;
;	ABC80 Routines
;
;	getk() Read key status
;
;	Maj 2000 - Stefano Bodrato
;
;
;	$Id: getk.asm,v 1.2 2001-04-13 14:13:59 stefano Exp $
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
