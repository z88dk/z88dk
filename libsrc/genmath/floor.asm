;       Small C+ Math Library
;       ceil(x)


                XLIB    floor


                XREF    int2
                XREF    fa
                XREF    norma


;
;       return largest integer not greater than
.FLOOR  LD      HL,FA+5
        LD      A,(HL)  ;fetch exponent
        CP      $A8
        LD      A,(FA)
        RET     NC      ;nc => binary point is right of lsb
        LD      A,(HL)
        CALL    INT2
        LD      (HL),$A8  ;place binary pt at end of fraction
        LD      A,E
        PUSH    AF
        LD      A,C
        RLA
        CALL    NORMA
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
