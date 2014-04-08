;       Small C+ Math Library

        XLIB amax
        
        LIB	ldbchl
        LIB	compare
        LIB	ldfabc



;
;       amax(a,b)       returns the greater of a and b
.amax   LD      HL,8    ;offset for 1st argument
        ADD     HL,SP
        CALL    ldbchl  ;bcixde := 1st argument
        CALL    compare
        JP      M,ldfabc
        RET
