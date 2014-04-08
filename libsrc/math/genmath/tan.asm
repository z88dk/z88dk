;       Small C+ Maths Routines
;
;       transcendental floating point routines
;

                XLIB    tan

                LIB     sin
                LIB     cos
                LIB     ldfabc

                LIB     pushfa
                XREF    pushf2
                LIB     div1



;double tan(double val)

;Looks odd, but don't worry..value is already in FA - no need for stack



;
.tan    CALL    pushfa  
        CALL    sin    
        POP     BC
        POP     IX
        POP     DE
        CALL    pushf2
        EX      DE,HL
        CALL    ldfabc  
        CALL    cos    
        JP      div1    
