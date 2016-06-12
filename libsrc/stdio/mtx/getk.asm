;
;	Memotech MTX stdio
;
;	getk() Read key status
;
;	Stefano Bodrato - Aug. 2010
;
;
;	$Id: getk.asm,v 1.3 2016-06-12 17:32:01 dom Exp $
;

        SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk

.getk
._getk
	call	$79
	ld	h,0
	ld	l,a
	ret
