;
;       Z88dk Generic Floating Point Math Library
;
;       Complement FASIGN and negate the fraction c ix de b
;
;       $Id: minusbc.asm,v 1.1 2008-07-27 21:44:57 aralbrec Exp $:


		XLIB	minusbc
		XREF	fasign

.MINUSBC LD     HL,FASIGN
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
        DEFB    $DD
        SBC     A,L
        DEFB    $DD
        LD      L,A
        LD      A,L
        DEFB    $DD
        SBC     A,H
        DEFB    $DD
        LD      H,A
        LD      A,L
        SBC     A,C
        LD      C,A
        RET


