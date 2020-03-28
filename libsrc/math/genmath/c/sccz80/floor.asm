;       Small C+ Math Library
;       ceil(x)


        SECTION code_fp
        PUBLIC    floor


        EXTERN	int2
        EXTERN	norma


        EXTERN    fa


;
;       return largest integer not greater than
.floor  LD      HL,fa+5
        LD      A,(HL)  ;fetch exponent
        CP      $A8
        LD      A,(fa)
        RET     NC      ;nc => binary point is right of lsb
        LD      A,(HL)
        CALL    int2
        LD      (HL),$A8  ;place binary pt at end of fraction
        LD      A,E
        PUSH    AF
        LD      A,C
        RLA
        CALL    norma
        POP     AF
        RET
;
;Huh..dunno what this is doing here..

;        LD      HL,FA+5
;        LD      (HL),$A8
;        INC     HL
;        LD      (HL),$80
;        LD      A,C
;        RLA
;        JP      NORMA
