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
                INCLUDE  "target/z88/def/fpp.def"

                PUBLIC    exp

                EXTERN	fsetup
                EXTERN	stkequ2

.exp
        call    fsetup
        fpp(FP_EXP)
        jp      stkequ2



