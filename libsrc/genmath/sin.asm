;       Small C+ Maths Routines
;
;       transcendental floating point routines
;

                XLIB    sin
		LIB	hlsub
		LIB	hladd
		LIB	addhalf

                LIB     evenpol
                LIB     floor

                LIB	pushfa
                LIB	ldfabc
                LIB	fsub
                LIB	sgn
                LIB	minusfa
                LIB	fdiv



;double sin(double val)

;Looks odd, but don't worry..value is already in FA - no need for stack




.SIN   CALL    PUSHFA  
        LD      BC,$8349       ;6.283185308... = 2*pi
        LD      IX,$0FDA
        LD      DE,$A222
        CALL    LDFABC  
        POP     BC
        POP     IX
        POP     DE
        CALL    FDIV    
        CALL    PUSHFA  
        CALL    FLOOR  
        POP     BC
        POP     IX
        POP     DE
        CALL    FSUB    
        LD      HL,KWARTER
        CALL    HLSUB   
        CALL    SGN     
        SCF     
        JP      P,SIN5  
        CALL    ADDHALF 
        CALL    SGN     
        OR      A
.SIN5   PUSH    AF
        CALL    P,MINUSFA
        LD      HL,KWARTER
        CALL    HLADD   
        POP     AF
        CALL    NC,MINUSFA
        LD      HL,SINCOEF
        JP      EVENPOL
;
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

