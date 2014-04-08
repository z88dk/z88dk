;       Small C+ Math Library


                XLIB    evenpol
                LIB     poly

                LIB	pushfa
                LIB	ldbcfa
                LIB	fmul

;
;       transcendental floating point routines: polynomial evaluation
;
.evenpol CALL   pushfa  
;        LD      DE,L265F
;        PUSH    DE
        PUSH    HL
        CALL    ldbcfa  
        CALL    fmul    
        POP     HL
        call    poly
;
.L265F  POP     BC
        POP     IX
        POP     DE
        JP      fmul
;

