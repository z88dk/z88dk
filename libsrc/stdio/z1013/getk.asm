;
;	Keyboard routines for the Robotron Z1013
;	By Stefano Bodrato - Aug. 2016
;
;	getk() Read key status
;
;
;	$Id: getk.asm $
;

		SECTION code_clib
		PUBLIC	getk
		PUBLIC	_getk

.getk
._getk
	
	ld	a,($F130)
	cp	$af
	jr	nz,no_Z1013_202
	
	XOR A
	LD	(4),A	; LASTK
	
.no_Z1013_202

	rst $20
	defb 4		; 'INKEY' function

.getk_done
IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	a,10
.not_return
ENDIF

	ld	l,a
	ld	h,0
	ret
