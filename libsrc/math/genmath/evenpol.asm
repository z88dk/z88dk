;       Small C+ Math Library


                XLIB    evenpol
                LIB     poly

                LIB	pushfa
                LIB	ldbcfa
                LIB	fmul

;
;       transcendental floating point routines: polynomial evaluation
;
.EVENPOL CALL   PUSHFA  
;        LD      DE,L265F
;        PUSH    DE
        PUSH    HL
        CALL    LDBCFA  
        CALL    FMUL    
        POP     HL
        call    poly
;
.L265F  POP     BC
        POP     IX
        POP     DE
        JP      FMUL
;

