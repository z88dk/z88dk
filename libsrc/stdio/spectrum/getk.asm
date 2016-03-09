;
;	Devilishly simple Spectrum Routines
;
;	getk() Read key status
;
;	17/5/99 djm
;
;
;	$Id: getk.asm,v 1.6 2016-03-09 22:25:54 dom Exp $
;

		SECTION code_clib
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
