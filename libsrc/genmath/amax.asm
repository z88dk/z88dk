;       Small C+ Math Library

        XLIB amax
        
        XREF    ldbchl
        XREF    compare
        XREF    ldfabc



;
;       amax(a,b)       returns the greater of a and b
.AMAX   LD      HL,8    ;offset for 1st argument
        ADD     HL,SP
        CALL    LDBCHL  ;bcixde := 1st argument
        CALL    COMPARE
        JP      M,LDFABC
        RET
