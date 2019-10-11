;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm


;double log10(double)  
;Number in FA..

                SECTION  code_fp
IF FORz88
                INCLUDE  "target/z88/def/fpp.def"
ELSE
		INCLUDE "fpp.def"
ENDIF

                PUBLIC    log10

                EXTERN	fsetup
                EXTERN	stkequ2

.log10
        call    fsetup
IF FORz88
        fpp(FP_LOG)
ELSE
	ld	a,+(FP_LOG)
	call	FPP
ENDIF
        jp      stkequ2



