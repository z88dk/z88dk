;
;       Z88dk Generic Floating Point Math Library
;
;       fraction add c ix de += (hl)
;
;       $Id: fradd.asm,v 1.1 2002-01-21 20:35:22 dom Exp $:

		XLIB	fradd

.FRADD  LD      A,(HL)
        ADD     A,E
        LD      E,A
        INC     HL
        LD      A,(HL)
        ADC     A,D
        LD      D,A
        INC     HL
        LD      A,(HL)
        DEFB    $DD
        ADC     A,L
        DEFB    $DD
        LD      L,A
        INC     HL
        LD      A,(HL)
        DEFB    $DD
        ADC     A,H
        DEFB    $DD
        LD      H,A
        INC     HL
        LD      A,(HL)
        ADC     A,C
        LD      C,A
        RET

