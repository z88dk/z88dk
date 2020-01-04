;
;	Sharp MZ2500 Routines
;
;	getk() Read key status
;	Stefano Bodrato - 2018
;
;
;	$Id: getk.asm $
;


        SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk

.getk
._getk
	ld	a,0
	rst 18h
	defb 0dh	; _INKEY
	jr nz,got_key
	
	xor a
	
.got_key
		cp	13	; was it ENTER ?
		jr	nz,noenter
IF STANDARDESCAPECHARS
		ld	a,10
ELSE
;		ld	a,13
ENDIF
.noenter
		ld	l,a
		ld	h,0
		ret
