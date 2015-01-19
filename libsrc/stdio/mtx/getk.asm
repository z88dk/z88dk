;
;	Memotech MTX stdio
;
;	getk() Read key status
;
;	Stefano Bodrato - Aug. 2010
;
;
;	$Id: getk.asm,v 1.2 2015-01-19 01:33:20 pauloscustodio Exp $
;

	PUBLIC	getk

.getk
	call	$79
	ld	h,0
	ld	l,a
	ret
