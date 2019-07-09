;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm


;double sin(double)
;Number in FA..

                SECTION  code_fp
IF FORz88
                INCLUDE  "target/z88/def/fpp.def"
ELSE
		INCLUDE "fpp.def"
ENDIF

                PUBLIC    sin

                EXTERN	fsetup
                EXTERN	stkequ2

.sin
        call    fsetup
IF FORz88
        fpp(FP_SIN)
ELSE
	ld	a,+(FP_SIN)
	call	FPP
ENDIF
        jp      stkequ2



