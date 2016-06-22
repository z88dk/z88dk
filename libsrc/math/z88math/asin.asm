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
                INCLUDE  "fpp.def"

                PUBLIC    asin

                EXTERN    fsetup
                EXTERN    stkequ2

.asin
        call    fsetup
        fpp(FP_ASN)
        jp      stkequ2



