;       Small C+ Math Library
;       General "fudging routine"

                XLIB    addhalf

                XREF    ldbchl
                XREF    fadd


;
.ADDHALF LD     HL,HALF
;.HLADD  
        CALL    LDBCHL
        JP      FADD



.HALF   DEFB    0,0,0,0,0,$80   ;0.5
;