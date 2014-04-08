;       Small C+ Math Library
;       General "fudging routine"

                XLIB    hladd

                LIB	ldbchl
                LIB	fadd


;
.hladd  
        CALL    ldbchl
        JP      fadd
