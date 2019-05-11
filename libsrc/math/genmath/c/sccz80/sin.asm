;       Small C+ Maths Routines
;
;       transcendental floating point routines
;

        SECTION code_fp
        PUBLIC  sin
        EXTERN   hlsub
        EXTERN   hladd
        EXTERN   addhalf

        EXTERN   evenpol
        EXTERN   floor

        EXTERN   pushfa
        EXTERN   ldfabc
        EXTERN   fsub
        EXTERN   sgn
        EXTERN   minusfa
        EXTERN   fdiv



;double sin(double val)

;Looks odd, but don't worry..value is already in FA - no need for stack




.sin    CALL    pushfa
        LD      BC,$8349       ;6.283185308... = 2*pi
        LD      IX,$0FDA
        LD      DE,$A222
        CALL    ldfabc
        POP     BC
        POP     IX
        POP     DE
        CALL    fdiv
        CALL    pushfa
        CALL    floor
        POP     BC
        POP     IX
        POP     DE
        CALL    fsub
        LD      HL,KWARTER
        CALL    hlsub
        CALL    sgn
        SCF     
        JP      P,SIN5  
        CALL    addhalf 
        CALL    sgn     
        OR      A
.SIN5   PUSH    AF
        CALL    P,minusfa
        LD      HL,KWARTER
        CALL    hladd   
        POP     AF
        CALL    NC,minusfa
        LD      HL,SINCOEF
        JP      evenpol
;
	SECTION	rodata_fp
.KWARTER
        defw     0
        defw     0
        defw    $7F00

.SINCOEF 
        defb     7
        defb      $90,$BA,$34,$76,$6A,$82
        defb      $E4,$E9,$E7,$4B,$F1,$84
        defb      $B1,$4F,$7F,$3B,$28,$86
        defb      $31,$B6,$64,$69,$99,$87
        defb      $E4,$36,$E3,$35,$23,$87
        defb      $24,$31,$E7,$5D,$A5,$86
        defb      $21,$A2,$DA,$0F,$49,$83

