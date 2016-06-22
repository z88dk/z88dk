;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm


;double tan(double)
;Number in FA..

                SECTION  code_fp
                INCLUDE  "fpp.def"

                PUBLIC    tan

                EXTERN	fsetup
                EXTERN	stkequ2

.tan
        call    fsetup
        fpp(FP_TAN)
        jp      stkequ2



