;       Small C+ Math Library
;       General "fudging routine"

                XLIB    hladd

                LIB	ldbchl
                LIB	fadd


;
.HLADD  
        CALL    LDBCHL
        JP      FADD
