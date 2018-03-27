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
	
	ld	a,($F012)
	cp  $af
	jr	nz,no_mon_202
	
;	rst $20
;	defb 4		; 'INKEY' function
	ld	a,(4)
	jr	getk_end
	
	
.no_mon_202
	rst $20
	defb 1		; 'INCH' function

.getk_end

IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	a,10
.not_return
ENDIF

	ld	l,a
	ld	h,0
	ret
