; example by Stefano Bodrato

            EXTERN  _putch
            EXTERN  PUBVAR
            PUBLIC  _PUBFN

    _PUBFN:
            LD      HL, PUBVAR
    PUBLP:
            LD      A,(HL)
            AND     A
            RET     Z
            PUSH    HL
            LD      L,A
            LD      H,0
            PUSH    HL
            CALL    _putch
            POP     HL
            POP     HL
            INC     HL
            JR      PUBLP

