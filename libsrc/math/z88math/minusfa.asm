;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm


;minusfa(double)  (internal function, negate number in FA)
;Number in FA..

                SECTION  code_fp
                INCLUDE  "fpp.def"

                PUBLIC    minusfa

                EXTERN	fsetup
                EXTERN	stkequ2

.minusfa
        call    fsetup
        fpp(FP_NEG)
        jp      stkequ2



