;       Small C+ Math Library
;       General "fudging routine"

                XLIB    hladd

                XREF    ldbchl
                XREF    fadd


;
.HLADD  
        CALL    LDBCHL
        JP      FADD
