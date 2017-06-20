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

	EXTERN key_to_asc
	
.getk
._getk
	call $Be53
	ld hl,0
	ret c
	
	; PC-G850
	call $bcc4
	
IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	a,10
.not_return
ENDIF

	ld	h,0
	ld	l,a
	ret
