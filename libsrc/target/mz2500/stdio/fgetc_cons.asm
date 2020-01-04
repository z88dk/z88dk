;
;	Sharp MZ2500 Routines
;
;	fgetc_cons() Wait for keypress
;	Stefano Bodrato - 2018
;
;
;	$Id: fgetc_cons.asm $
;

        SECTION code_clib
	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons

.fgetc_cons
._fgetc_cons
	
	ld	a,1
	rst 18h
	defb 0dh	; _INKEY
	
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
