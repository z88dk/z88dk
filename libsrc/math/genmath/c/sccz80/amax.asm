;       Small C+ Math Library

	SECTION code_fp
        PUBLIC amax
        
        EXTERN	ldbchl
        EXTERN	compare
        EXTERN	ldfabc



;
;       amax(a,b)       returns the greater of a and b
.amax   LD      HL,8    ;offset for 1st argument
        ADD     HL,SP
        CALL    ldbchl  ;bcixde := 1st argument
        CALL    compare
        JP      M,ldfabc
        RET
