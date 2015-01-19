;
;	Devilishly simple Spectrum Routines
;
;	getk() Read key status
;
;	17/5/99 djm
;
;
;	$Id: getk.asm,v 1.4 2015-01-19 01:33:21 pauloscustodio Exp $
;


		PUBLIC	getk

.getk
	ld	h,0
	ld	a,(23560)
	ld	l,a
	and	a
	ret	z
	xor	a
	ld	(23560),a
	ret
