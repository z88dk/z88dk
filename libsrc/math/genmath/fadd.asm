;
;       Z88dk Generic Floating Point Math Library
;
;	Add bc ix de to FA
;
;       $Id: fadd.asm,v 1.5 2016-06-21 21:16:49 dom Exp $:


        SECTION code_fp
	PUBLIC	fadd

	EXTERN	ldbcfa
	EXTERN	ldfabc
	EXTERN	norma
	EXTERN	unpack
	EXTERN	rshift
	EXTERN	pack
	EXTERN	fradd

	EXTERN	rsh8
	EXTERN	fa

.fadd   LD      A,B
        OR      A
        RET     Z       ;z => number to be added is zero
        LD      A,(fa+5)
        OR      A
        JP      Z,ldfabc ;z => accumulator is zero,
;                               just load number
        SUB     B
        JR      NC,ADD2 ;nc => accumulator has larger number
        NEG             ;reverse accumulator & bc ix de...
        EXX
        PUSH    IX
        CALL    ldbcfa
        EXX
        EX      (SP),IX
        CALL    ldfabc
        EXX
        POP     IX      ;...end of reversing
.ADD2   CP      $29
        RET     NC      ;nc => addition makes no change
        PUSH    AF      ;save difference of exponents
        CALL    unpack  ;restore hidden bit & compare signs
        LD      H,A     ;save difference in signs
        POP     AF      ;recall difference of exponents
        CALL    rshift  ;shift  c ix de b  right by (a)
        OR      H
        LD      HL,fa
        JP      P,ADD4  ;p => opposite signs, must subtract
        CALL    fradd   ;c ix de += FA
        JP      NC,pack ;nc => adding caused no carry
        INC     HL
        INC     (HL)    ;increment exponent
        ret     z
;        JP      Z,OFLOW
        LD      L,1
        CALL    rsh8    ;shift  c ix de b  right by 1
        JP      pack    ;round, hide msb, & load into FA
;
.ADD4   XOR     A       ;negate b...
        SUB     B
        LD      B,A
        LD      A,(HL)  ;c ix de -= FA...
        SBC     A,E
        LD      E,A
        INC     HL
        LD      A,(HL)
        SBC     A,D
        LD      D,A
        INC     HL
        LD      A,(HL)
        SBC     A,IXL
        LD      IXL,A
        INC     HL
        LD      A,(HL)
        SBC     A,IXH
        LD      IXH,A
        INC     HL
        LD      A,(HL)
        SBC     A,C
        LD      C,A     ;...end of subtraction, fall into...
        jp      norma


