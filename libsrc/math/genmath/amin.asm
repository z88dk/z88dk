;       Small C+ Math Library

        PUBLIC amin
        
        EXTERN	ldbchl
        EXTERN	compare
        EXTERN	ldfabc


;
;       amin(a,b)

.amin   LD      HL,8
        ADD     HL,SP
        CALL    ldbchl
        CALL    compare
        JP      P,ldfabc
        RET
