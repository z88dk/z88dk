;       Small C+ Maths Routines
;
;       transcendental floating point routines
;


        SECTION code_fp
        PUBLIC    tan

        EXTERN     sin
        EXTERN     cos
        EXTERN     ldfabc

        EXTERN     pushfa
        EXTERN    pushf2
        EXTERN     div1



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
