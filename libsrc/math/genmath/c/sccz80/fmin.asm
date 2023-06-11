;       Small C+ Math Library

        SECTION code_fp
        PUBLIC fmin
        
        EXTERN	ldbchl
        EXTERN	compare
        EXTERN	ldfabc


;
;       fmin(a,b)

.fmin   LD      HL,8
        ADD     HL,SP
        CALL    ldbchl
        CALL    compare
        JP      P,ldfabc
        RET
