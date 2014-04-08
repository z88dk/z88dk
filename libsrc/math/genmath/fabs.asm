;       Small C+ Math Library
;       fabs(x)



                XLIB    fabs
                LIB     minusfa


                LIB	sgn
                XREF    fa


;
.fabs  CALL    sgn
        RET     P
        jp      minusfa

