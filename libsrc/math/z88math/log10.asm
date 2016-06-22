;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm


;double log10(double)  
;Number in FA..

                SECTION  code_fp
                INCLUDE  "fpp.def"

                PUBLIC    log10

                EXTERN	fsetup
                EXTERN	stkequ2

.log10
        call    fsetup
        fpp(FP_LOG)
        jp      stkequ2



