;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm


;double log(double)     - natural log
;Number in FA..

                SECTION  code_fp
                INCLUDE  "fpp.def"

                PUBLIC    log

                EXTERN	fsetup
                EXTERN	stkequ2

.log
        call    fsetup
        fpp(FP_LN)
        jp      stkequ2



