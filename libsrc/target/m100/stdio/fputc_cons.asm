;
;       TRS 80 Model 100 C Library
;
;	Print character to the screen
;
;	Stefano Bodrato - Feb 2020
;
;
;	$Id: fputc_cons.asm$
;
;	Prints at cooards from 4020-4021

	  SECTION code_clib
          PUBLIC  fputc_cons_native


.fputc_cons_native
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
;	cp	12
;	jr	z,cls
IF STANDARDESCAPECHARS
	cp  13
	ret z
	cp  10
	jr  nz,notCR
	ld	a,13
.notCR
ENDIF

	rst $20
	ret

