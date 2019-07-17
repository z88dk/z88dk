;
;	Sharp PC G-800 family stdio
;
;	getk() Read key status
;
;	Stefano Bodrato - 2017
;
;
;	$Id: getk_850.asm - stefano Exp $
;

        SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk

.getk
._getk
	call $BE53	; ket key code (if no key, A=0 and CY=0)
	call $BE56	; convert key code to value
	
IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	a,10
.not_return
ENDIF

	ld	h,0
	ld	l,a
	ret
