;       Small C+ Math Library

        XLIB amin
        
        LIB	ldbchl
        LIB	compare
        LIB	ldfabc


;
;       amin(a,b)

.aMIN   LD      HL,8
        ADD     HL,SP
        CALL    LDBCHL
        CALL    COMPARE
        JP      P,LDFABC
        RET
