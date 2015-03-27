;
;       Z88dk Generic Floating Point Math Library
;
;       fraction add c ix de += (hl)
;
;       $Id: mgm_fradd.asm,v 1.1 2015-03-27 06:03:29 aralbrec Exp $:

		PUBLIC	fradd

.fradd  LD      A,(HL)
        ADD     A,E
        LD      E,A
        INC     HL
        LD      A,(HL)
        ADC     A,D
        LD      D,A
        INC     HL
        LD      A,(HL)
        ADC     A,IXL
        LD      IXL,A
        INC     HL
        LD      A,(HL)
        ADC     A,IXH
        LD      IXH,A
        INC     HL
        LD      A,(HL)
        ADC     A,C
        LD      C,A
        RET

