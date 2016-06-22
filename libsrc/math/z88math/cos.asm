;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm


;double cos(double)
;Number in FA..

                SECTION  code_fp
                INCLUDE  "fpp.def"

                PUBLIC    cos

                EXTERN	fsetup
                EXTERN	stkequ2

.cos
        call    fsetup
        fpp(FP_COS)
        jp      stkequ2



