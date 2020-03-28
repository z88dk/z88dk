;       Small C+ Math Library
;       General "fudging routine"

        SECTION code_fp
        PUBLIC    hlsub

        EXTERN	ldbchl
        EXTERN	fsub


;

.hlsub  CALL    ldbchl
        JP      fsub
;
