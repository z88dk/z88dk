;
;       TRS 80 Model 100 C Library
;
;	getk() Read key status
;
;	Stefano Bodrato - Feb 2020
;	Alexei Gordeev - Nov 2020
;
;
;	$Id: getk.asm $
;

        SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk
	INCLUDE "target/m100/def/romcalls.def"
.getk
._getk

	ROMCALL
	defw	KYPEND
	ld	a,0
	JP	Z,INKEY_S_0

	ROMCALL
	defw	KYREAD

IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	a,10
.not_return
ENDIF

.INKEY_S_0
        ld      l,a
	ld	h,0
	ret
