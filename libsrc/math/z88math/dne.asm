;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dne.asm,v 1.3 2015-01-21 10:56:30 stefano Exp $

		PUBLIC	dne

		EXTERN	fsetup
		EXTERN	stkequcmp

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

