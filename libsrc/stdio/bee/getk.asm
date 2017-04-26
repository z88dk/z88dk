;
;	MicroBEE Stdio
;
;	getk() Read key status
;
;	Stefano Bodrato - 2016
;
;
;	$Id: getk.asm,v 1.1 2016-11-15 08:11:11 stefano Exp $
;

        SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk


.getk
._getk
	call $803F
	jr z,got
	xor a
.got

IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	a,10
.not_return
ENDIF

	ld	h,0
	ld	l,a
	ret
