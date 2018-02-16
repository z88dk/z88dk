;
;	Keyboard routines for the Robotron Z1013
;	By Stefano Bodrato - Aug. 2016
;
;	getk() Read key status
;
;
;	$Id: getk.asm,v 1.1 2016-08-05 07:04:10 stefano Exp $
;

		SECTION code_clib
		PUBLIC	getk
		PUBLIC	_getk

.getk
._getk

	rst $20
	defb 4		; 'INKEY' function

.gkret


IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	a,10
.not_return
ENDIF

	ld	l,a
	ld	h,0
	ret
