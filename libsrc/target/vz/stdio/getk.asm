;
;	Devilishly simple VZ Routines
;
;	getk() Read key status
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: getk.asm,v 1.4 2016-06-10 23:56:01 dom Exp $
;

        SECTION code_clib
		PUBLIC	getk
		PUBLIC	_getk

.getk
._getk
	call	$2efd		;scan keyboard once

IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	a,10
.not_return
ENDIF

		ld	l,a
		ld	h,0
		ret
