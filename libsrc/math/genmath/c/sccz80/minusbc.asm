;
;       Z88dk Generic Floating Point Math Library
;
;       Complement FASIGN and negate the fraction c ix de b
;
;       $Id: minusbc.asm,v 1.5 2016-06-21 21:16:49 dom Exp $:

        SECTION code_fp
	PUBLIC	minusbc
	EXTERN	fasign

.minusbc LD     HL,fasign
        LD      A,(HL)
        CPL
        LD      (HL),A
        XOR     A
        LD      L,A
        LD      H,A
        SUB     B
        LD      B,A
        LD      A,L
        SBC     HL,DE
        EX      DE,HL
        LD      L,A
        SBC     A,IXL
        LD      IXL,A
        LD      A,L
        SBC     A,IXH
        LD      IXH,A
        LD      A,L
        SBC     A,C
        LD      C,A
        RET


