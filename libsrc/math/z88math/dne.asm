;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dne.asm,v 1.2 2009-06-22 21:44:17 dom Exp $

		XLIB	dne

		LIB	fsetup
		LIB	stkequcmp

		INCLUDE	"fpp.def"

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

