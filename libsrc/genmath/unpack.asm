;
;       Z88dk Generic Floating Point Math Library
;
;       Unpack FP number
;
;       $Id: unpack.asm,v 1.1 2002-01-21 20:35:22 dom Exp $:

		XLIB	unpack

		XREF	fa

.UNPACK LD      HL,FA+4
        LD      A,(HL)  ;get MSB of fraction
        RLCA            ;rotate sign bit into lsb
        SCF             ;set carry
        RRA             ;rotate sign bit into cy, cy into msb
        LD      (HL),A  ;restore MSB (with hidden bit restored)
        CCF             ;complement sign bit...
        RRA
        INC     HL
        INC     HL
        LD      (HL),A  ;...and save in msb of FASIGN
        LD      A,C     ;similarly, get sign bit of bc ix de...
        RLCA
        SCF
        RRA
        LD      C,A     ;...restore hidden bit...
        RRA
        XOR     (HL)    ;...and compare with sign of FA.
        RET


