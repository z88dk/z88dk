;       Small C+ Math Library

        XLIB amin
        
        LIB	ldbchl
        LIB	compare
        LIB	ldfabc


;
;       amin(a,b)

.amin   LD      HL,8
        ADD     HL,SP
        CALL    ldbchl
        CALL    compare
        JP      P,ldfabc
        RET
