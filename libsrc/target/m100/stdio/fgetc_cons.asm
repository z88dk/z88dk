;
;       TRS 80 Model 100 C Library
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - Feb 2020
;	Alexei Gordeev - Nov 2020
;
;
;	$Id: fgetc_cons.asm $
;

        SECTION code_clib
	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons
	INCLUDE "target/m100/def/romcalls.def"
	
.fgetc_cons
._fgetc_cons

	ROMCALL
	defw	KYREAD

	;and	a
	;jr	z,fgetc_cons

IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	a,10
.not_return
ENDIF

        ld      l,a
	ld	h,0
	ret

