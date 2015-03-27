;       Small C+ Math Library
;       General "fudging routine"

                PUBLIC    hlsub

                EXTERN	ldbchl
                EXTERN	fsub


;

.hlsub  CALL    ldbchl
        JP      fsub
;
