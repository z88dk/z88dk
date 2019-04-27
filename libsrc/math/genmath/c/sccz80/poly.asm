;       Small C+ Math Library
;       More polynomial evaluation

        SECTION code_fp
        PUBLIC    poly

        EXTERN     pushfa
        EXTERN     ldbchl
        EXTERN     fadd
        EXTERN     fmul

        EXTERN    dload

;
.poly   CALL    pushfa  
        LD      A,(HL)
        INC     HL
        CALL    dload   
        DEFB    $FE    ;"ignore next byte"
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
        CALL    fmul    
        POP     HL
        CALL    ldbchl  
        PUSH    HL
        CALL    fadd    
        POP     HL
        JR      POL3    
;
