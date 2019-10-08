;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm


;double fabs(double)  
;Number in FA..

                SECTION  code_fp
IF FORz88
		INCLUDE "target/z88/def/fpp.def"
ELSE
		INCLUDE "fpp.def"
ENDIF


                PUBLIC    fabs

                EXTERN	fsetup
                EXTERN	stkequ2

.fabs
        call    fsetup
IF FORz88
        fpp(FP_ABS)
ELSE
	ld	a,+(FP_ABS)
	call	FPP
ENDIF
        jp      stkequ2



