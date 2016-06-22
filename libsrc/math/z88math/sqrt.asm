;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm


;double sqrt(double)  
;Number in FA..

                SECTION  code_fp
                INCLUDE  "fpp.def"

                PUBLIC    sqrt

                EXTERN	fsetup
                EXTERN	stkequ2

.sqrt
        call    fsetup
        fpp(FP_SQR)
        jp      stkequ2



