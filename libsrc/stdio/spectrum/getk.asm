;
;	Devilishly simple Spectrum Routines
;
;	getk() Read key status
;
;	17/5/99 djm
;
;
;	$Id: getk.asm,v 1.5 2016-03-05 00:55:18 dom Exp $
;


		PUBLIC	getk
		PUBLIC	_getk

.getk
._getk
	ld	h,0
	ld	a,(23560)
	ld	l,a
	and	a
	ret	z
	xor	a
	ld	(23560),a
	ret
