;       Small C+ Math Library
;       General "fudging routine"

                PUBLIC    hladd

                EXTERN	ldbchl
                EXTERN	fadd


;
.hladd  
        CALL    ldbchl
        JP      fadd
