;
;       Z88dk Generic Floating Point Math Library
;
;       set flags per FA - ( bc ix de )
;
;       $Id: compare.asm,v 1.5 2016-06-21 21:16:49 dom Exp $:

        SECTION code_fp
	PUBLIC	compare

	EXTERN	sgn

	EXTERN	setflgs
	EXTERN	fa

.compare 
	LD     A,B
        OR      A
        JP      Z,sgn           ;bc ix de = 0, so
;                               sign of FA is result
        CALL    sgn
        LD      A,C
        JP      Z,setflgs       ;FA = 0, so sign of
;                               -(bc ix de) is result
        LD      HL,fa+4
        XOR     (HL)
        LD      A,C
        JP      M,setflgs       ;operands have opposite
;                               signs, so result is sign
;                               of -(bc ix de)

        CALL    CPFRAC
        RRA                     ;recover cy bit
        XOR     C       ;reverse sign if numbers are negative
        JP      setflgs

.CPFRAC INC     HL      ;compare  bc ix de  to (HL)
        LD      A,B
        CP      (HL)
        RET     NZ
        DEC     HL
        LD      A,C
        CP      (HL)
        RET     NZ
        DEC     HL
        LD      A,IXH
        CP      (HL)
        RET     NZ
        DEC     HL
		LD      A,IXL
        CP      (HL)
        RET     NZ
        DEC     HL
        LD      A,D
        CP      (HL)
        RET     NZ
        DEC     HL
        LD      A,E
        SUB     (HL)
        RET     NZ
        POP     HL      ;return zero to program
        RET             ;that called "COMPARE"


