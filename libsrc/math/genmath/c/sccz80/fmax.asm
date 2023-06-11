;       Small C+ Math Library

	SECTION code_fp
        PUBLIC fmax
        
        EXTERN	ldbchl
        EXTERN	compare
        EXTERN	ldfabc



;
;       fmax(a,b)       returns the greater of a and b
.fmax   LD      HL,8    ;offset for 1st argument
        ADD     HL,SP
        CALL    ldbchl  ;bcixde := 1st argument
        CALL    compare
        JP      M,ldfabc
        RET
