;
;	Devilishly simple Spectrum Routines
;
;	getk() Read key status
;
;	17/5/99 djm
;
;
;	$Id: getk.asm,v 1.3 2003-01-24 23:20:17 dom Exp $
;


		XLIB	getk

.getk
	ld	h,0
	ld	a,(23560)
	ld	l,a
	and	a
	ret	z
	xor	a
	ld	(23560),a
	ret
