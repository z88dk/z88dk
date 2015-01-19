;       Small C+ Math Library
;       fabs(x)



                PUBLIC    fabs
                EXTERN     minusfa


                EXTERN	sgn
                EXTERN    fa


;
.fabs  CALL    sgn
        RET     P
        jp      minusfa

