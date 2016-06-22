;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm


;double floor(double)  
;Number in FA..

                SECTION  code_fp
                INCLUDE  "fpp.def"

                PUBLIC    floor

                EXTERN	fsetup
                EXTERN	stkequ2

.floor
        call    fsetup
        fpp(FP_INT)             ;floor it (round down!)
        jp      stkequ2



