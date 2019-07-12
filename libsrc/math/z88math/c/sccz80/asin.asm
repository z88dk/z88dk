;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm


;double asin(double)
;Number in FA..

                SECTION  code_fp
IF FORz88
                INCLUDE  "target/z88/def/fpp.def"
ELSE
		INCLUDE "fpp.def"
ENDIF

                PUBLIC    asin

                EXTERN    fsetup
                EXTERN    stkequ2

.asin
        call    fsetup
IF FORz88
        fpp(FP_ASN)
ELSE
	ld	a,+(FP_ASN)
	call	FPP
ENDIF
        jp      stkequ2



