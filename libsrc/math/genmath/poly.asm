;       Small C+ Math Library
;       More polynomial evaluation

                XLIB    poly

                LIB	pushfa
                LIB	ldbchl
                LIB	fadd
                LIB	fmul

                XREF    dload

;
.POLY   CALL    PUSHFA  
        LD      A,(HL)
        INC     HL
        CALL    DLOAD   
        DEFB      $FE    ;"ignore next byte"
.POL3   POP     AF
        POP     BC
        POP     IX
        POP     DE
        DEC     A
        RET     Z
        PUSH    DE
        PUSH    IX
        PUSH    BC
        PUSH    AF
        PUSH    HL
        CALL    FMUL    
        POP     HL
        CALL    LDBCHL  
        PUSH    HL
        CALL    FADD    
        POP     HL
        JR      POL3    
;
