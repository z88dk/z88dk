;
;	Devilishly simple Spectrum Routines
;
;	getk() Read key status
;
;	17/5/99 djm
;
;
;	$Id: getk.asm,v 1.2 2001-04-13 14:14:00 stefano Exp $
;


		XLIB	getk

.getk
	ld	a,(23560)
	ld	l,a
	xor	a
	ld	(23560),a
	ld	h,a
	ret
