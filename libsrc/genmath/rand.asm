;       Small C+ Math package
;
;
;       Generic rand() function



                XLIB    fprand
                
                XREF    fp_seed
                XREF    dload
                XREF    fmul
                XREF    fadd
                XREF    ldbcfa
                XREF    fa
                XREF    fasign
                XREF    dstore
                XREF    norm
                



.fpRAND
        LD      HL,fp_SEED
        CALL    DLOAD
        LD      BC,$9835        ; 11879545.
        LD      IX,$447A
        LD      DE,0
        CALL    FMUL
        LD      BC,$6828        ; 3.92767775e-8
        LD      IX,$B146
        LD      DE,0
        CALL    FADD
        CALL    LDBCFA
        LD      A,E
        LD      E,C
        LD      C,A
        LD      HL,FASIGN
        LD      (HL),$80
        DEC     HL
        LD      B,(HL)
        LD      (HL),$80
        CALL    NORM
        LD      HL,fp_SEED
        JP      DSTORE
