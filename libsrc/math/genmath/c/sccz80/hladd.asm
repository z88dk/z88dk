;       Small C+ Math Library
;       General "fudging routine"

        SECTION code_fp
        PUBLIC    hladd

        EXTERN	ldbchl
        EXTERN	fadd


;
.hladd  
        CALL    ldbchl
        JP      fadd
