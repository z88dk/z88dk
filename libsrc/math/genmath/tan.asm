;       Small C+ Maths Routines
;
;       transcendental floating point routines
;

                XLIB    tan

                LIB     sin
                LIB     cos
                LIB	ldfabc

                LIB	pushfa
                XREF    pushf2
                LIB	div1



;double tan(double val)

;Looks odd, but don't worry..value is already in FA - no need for stack



;
.TAN    CALL    PUSHFA  
        CALL    SIN    
        POP     BC
        POP     IX
        POP     DE
        CALL    PUSHF2
        EX      DE,HL
        CALL    LDFABC  
        CALL    COS    
        JP      DIV1    
