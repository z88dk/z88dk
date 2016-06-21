;       Small C+ Math package
;
;
;       Generic rand() function


        SECTION code_fp
        PUBLIC    fprand
                
        EXTERN	fmul
        EXTERN	fadd
        EXTERN	ldbcfa
        EXTERN	norm
                

        EXTERN    fp_seed
        EXTERN    dload
        EXTERN    fa
        EXTERN    fasign
        EXTERN    dstore


.fprand
        LD      HL,fp_seed
        CALL    dload
        LD      BC,$9835        ; 11879545.
        LD      IX,$447A
        LD      DE,0
        CALL    fmul
        LD      BC,$6828        ; 3.92767775e-8
        LD      IX,$B146
        LD      DE,0
        CALL    fadd
        CALL    ldbcfa
        LD      A,E
        LD      E,C
        LD      C,A
        LD      HL,fasign
        LD      (HL),$80
        DEC     HL
        LD      B,(HL)
        LD      (HL),$80
        CALL    norm
        LD      HL,fp_seed
        JP      dstore
