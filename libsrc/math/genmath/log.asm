;       Small C+ Math functions


        SECTION code_fp
        PUBLIC    log

        EXTERN	hlsub
        EXTERN	evenpol
        EXTERN	sgn
        EXTERN	fdiv
        EXTERN	fmul
        EXTERN	fadd
        EXTERN	norma
        EXTERN	pushfa


        EXTERN    fa
        EXTERN    fasign

;
;       transcendental functions: log
;
;


;
.log    CALL    sgn
        OR      A
        ret     pe      ;urk!..
        LD      HL,fa+5 
        LD      A,(HL)
        LD      BC,$8035        ; 1/sqrt(2)
        LD      IX,$04F3
        LD      DE,$33FA
        SUB     B
        PUSH    AF
        LD      (HL),B
        PUSH    DE
        PUSH    IX
        PUSH    BC
        CALL    fadd    
        POP     BC
        POP     IX
        POP     DE
        INC     B
        CALL    fdiv    
        LD      HL,ONE
        CALL    hlsub
        LD      HL,LOGCOEF
        CALL    evenpol
        LD      BC,$8080        ; -0.5
        LD      IX,0
        LD      DE,0
        CALL    fadd
        POP     AF
        CALL    L247E
        LD      BC,$8031        ; ln(2)
        LD      IX,$7217
        LD      DE,$F7D2
        JP      fmul
;
;
; don't know what this is, it seems to be part of log()
;
.L247E  CALL    pushfa
        CALL    L27EC
        POP     BC
        POP     IX
        POP     DE
        JP      fadd
;
;
.L27EC  LD      B,$88   ; 128.
        LD      DE,0
.L27F1  LD      HL,fa+5
        LD      C,A
        PUSH    DE
        POP     IX
        LD      DE,0
        LD      (HL),B  ;store exponent
        LD      B,0
        INC     HL
        LD      (HL),$80        ;store minus sign
        RLA
        JP      norma
;
        EX      DE,HL
        XOR     A
        LD      B,$98
        JR      L27F1
        LD      B,C
.L280C  LD      D,B
        LD      E,0
        LD      HL,L0F2E
        LD      (HL),E
        LD      B,$90
        JR      L27F1
        LD      B,A
        XOR     A
        JR      L280C
;
	SECTION bss_fp
.L0F2E  DEFB    0
;
	SECTION rodata_fp
.ONE    DEFW      0
        DEFW      0
        DEFW      $8100
;
.LOGCOEF 
        defb     6
        defb      $23,$85,$AC,$C3,$11,$7F
        defb      $53,$CB,$9E,$B7,$23,$7F
        defb      $CC,$FE,$A6,$0D,$53,$7F
        defb      $CB,$5C,$60,$BB,$13,$80
        defb      $DD,$E3,$4E,$38,$76,$80
        defb      $5C,$29,$3B,$AA,$38,$82
