;
;       Z88dk Generic Floating Point Math Library
;
;	Add bc ix de to FA
;
;       $Id: fadd.asm,v 1.1 2002-01-21 20:35:22 dom Exp $:


		XLIB	fadd

		LIB	ldbcfa
		LIB	ldfabc
		LIB	norma
		LIB	unpack
		LIB	rshift
		LIB	pack
		LIB	fradd

		XREF	rsh8
		XREF	fa

.FADD   LD      A,B
        OR      A
        RET     Z       ;z => number to be added is zero
        LD      A,(FA+5)
        OR      A
        JP      Z,LDFABC ;z => accumulator is zero,
;                               just load number
        SUB     B
        JR      NC,ADD2 ;nc => accumulator has larger number
        NEG             ;reverse accumulator & bc ix de...
        EXX
        PUSH    IX
        CALL    LDBCFA
        EXX
        EX      (SP),IX
        CALL    LDFABC
        EXX
        POP     IX      ;...end of reversing
.ADD2   CP      $29
        RET     NC      ;nc => addition makes no change
        PUSH    AF      ;save difference of exponents
        CALL    UNPACK  ;restore hidden bit & compare signs
        LD      H,A     ;save difference in signs
        POP     AF      ;recall difference of exponents
        CALL    RSHIFT  ;shift  c ix de b  right by (a)
        OR      H
        LD      HL,FA
        JP      P,ADD4  ;p => opposite signs, must subtract
        CALL    FRADD   ;c ix de += FA
        JP      NC,PACK ;nc => adding caused no carry
        INC     HL
        INC     (HL)    ;increment exponent
        ret     z
;        JP      Z,OFLOW
        LD      L,1
        CALL    RSH8    ;shift  c ix de b  right by 1
        JP      PACK    ;round, hide msb, & load into FA
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
        DEFB    $DD
        SBC     A,L
        DEFB    $DD
        LD      L,A
        INC     HL
        LD      A,(HL)
        DEFB    $DD
        SBC     A,H
        DEFB    $DD
        LD      H,A
        INC     HL
        LD      A,(HL)
        SBC     A,C
        LD      C,A     ;...end of subtraction, fall into...
	jp      norma


