;
;	Memotech MTX stdio
;
;	getk() Read key status
;
;	Stefano Bodrato - Aug. 2010
;
;
;	$Id: getk.asm,v 1.3+ (now on GIT) $
;

        SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk

.getk
._getk
	call	$79
  
IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	a,10
.not_return
ENDIF

	ld	h,0
	ld	l,a
	ret
