;       Small C+ Math Library

        XLIB amin
        
        XREF    ldbchl
        XREF    compare
        XREF    ldfabc


;
;       amin(a,b)

.aMIN   LD      HL,8
        ADD     HL,SP
        CALL    LDBCHL
        CALL    COMPARE
        JP      P,LDFABC
        RET