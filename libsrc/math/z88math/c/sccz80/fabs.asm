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
		INCLUDE "target/z88/def/fpp.def"


                PUBLIC    fabs

                EXTERN	fsetup
                EXTERN	stkequ2

.fabs
        call    fsetup
        fpp(FP_ABS)
        jp      stkequ2



