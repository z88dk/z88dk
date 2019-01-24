;
;	stdio - Sanyo PHC-25
;
;	getk(), Read key status
;
;
;	$Id: getk.asm $
;

		SECTION code_clib
		PUBLIC	getk
		PUBLIC	_getk

.getk
._getk
	ld	h,0
	ld	a,($F95C)
	ld	l,a
	
IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	l,10
.not_return
ENDIF

	cp  29
	jr  nz,nobs
	ld	l,8
.nobs

	xor	a
	ld	($F95C),a
	ret
