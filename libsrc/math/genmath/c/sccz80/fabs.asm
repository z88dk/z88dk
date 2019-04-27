;       Small C+ Math Library
;       fabs(x)


        SECTION code_fp
        PUBLIC    fabs
        EXTERN     minusfa


        EXTERN	sgn
        EXTERN    fa


;
.fabs  CALL    sgn
        RET     P
        jp      minusfa

