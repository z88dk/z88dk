;
;	Devilishly simple Spectrum Routines
;
;	getk() Read key status
;
;	17/5/99 djm


		XLIB	getk

.getk
	ld	a,(23560)
	ld	l,a
	xor	a
	ld	(23560),a
	ld	h,a
	ret
