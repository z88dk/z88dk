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
                INCLUDE  "fpp.def"

                PUBLIC    sin

                EXTERN	fsetup
                EXTERN	stkequ2

.sin
        call    fsetup
        fpp(FP_SIN)
        jp      stkequ2



