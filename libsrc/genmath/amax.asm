;       Small C+ Math Library

        XLIB amax
        
        LIB	ldbchl
        LIB	compare
        LIB	ldfabc



;
;       amax(a,b)       returns the greater of a and b
.AMAX   LD      HL,8    ;offset for 1st argument
        ADD     HL,SP
        CALL    LDBCHL  ;bcixde := 1st argument
        CALL    COMPARE
        JP      M,LDFABC
        RET
