;
; 	Basic keyboard handling for the Jupiter ACE
;	By Stefano Bodrato Feb. 2001
;
;	getk() Read key status
;
;
;	$Id: getk.asm,v 1.5 2016-05-18 21:25:24 dom Exp $
;

	SECTION	code_clib
	PUBLIC	getk
	PUBLIC	_getk

.getk
._getk

	call	$336

	cp	5	; Delete?
	jr	nz,nodel
	ld	a,8
.nodel

IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	a,10
.not_return
ENDIF

	ld	l,a
	ld	h,0
	ret
