;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dge.asm,v 1.1 2002-01-21 20:36:07 dom Exp $

		XLIB	dne

		LIB	fsetup
		LIB	stkequcmp

		INCLUDE	"#fpp.def"

; TOS != FA?
.dne
	call	fsetup
	fpp(FP_EQ)
;Invert the result, not particularly elegant, but it works!
        ex      de,hl
        ld      hl,0
        ld      a,e
        or      d
        jp      nz,stkequcmp
        inc     hl
	jp	stkequcmp

