;
;       Z88dk Generic Floating Point Math Library
;
;	divide bc ix de by FA, leave result in FA
;
;	$Id: fdiv.asm,v 1.1 2002-01-21 20:35:22 dom Exp $



		XLIB	fdiv

		LIB	sgn
		LIB	div14
		LIB	pack2
		LIB	norm4


		XREF	FA
		XREF	EXTRA


.fdiv
	call	sgn
	ret	z		;dividing by zero..
        LD      L,$FF  ;"quotient" flag
        CALL    DIV14   ;find quotient exponent
        PUSH    IY
        INC     (HL)
        INC     (HL)
        DEC     HL
        PUSH    HL      ; c' h'l' d'e' (divisor) = FA...
        EXX
        POP     HL
        LD      C,(HL)
        DEC     HL
        LD      D,(HL)
        DEC     HL
        LD      E,(HL)
        DEC     HL
        LD      A,(HL)
        DEC     HL
        LD      L,(HL)
        LD      H,A
        EX      DE,HL
        EXX
        LD      B,C     ; b iy hl (dividend) = c ix de...
        EX      DE,HL
        PUSH    IX
        POP     IY
        XOR     A       ; c ix de (quotient) = 0...
        LD      C,A
        LD      D,A
        LD      E,A
        LD      IX,0
        LD      (EXTRA),A
.DIV2   PUSH    HL      ;save b iy hl in case the subtraction
        PUSH    IY      ; proves to be unnecessary
        PUSH    BC
        PUSH    HL      ; EXTRA b iy hl (dividend)  -=
        LD      A,B     ;       c' h'l' d'e' (divisor)...
        EXX
        EX      (SP),HL
        OR      A
        SBC     HL,DE
        EX      (SP),HL
        EX      DE,HL
        PUSH    IY
        EX      (SP),HL
        SBC     HL,DE
        EX      (SP),HL
        POP     IY
        EX      DE,HL
        SBC     A,C
        EXX
        POP     HL
        LD      B,A
        LD      A,(EXTRA)
        SBC     A,0
        CCF
        JR      NC,DIV4 ; nc => subtraction caused carry
        LD      (EXTRA),A
        POP     AF      ;discard saved value of dividend...
        POP     AF
        POP     AF
        SCF
        JR      DIV6
.DIV4   POP     BC      ;restore dividend...
        POP     IY
        POP     HL
;
.DIV6   INC     C
        DEC     C
        RRA
       JP      M,DIV12
        RLA       ;shift  c ix de a (quotient)  left by 1...
        RL      E
        RL      D
        EX      AF,AF'  ;(these 6 lines are  adc ix,ix...)
        ADD     IX,IX
        EX      AF,AF'
        JR      NC,DIV8
        INC     IX
.DIV8   EX      AF,AF'
        RL      C       ;...end of  c ix de a  shifting
        ADD     HL,HL   ;shift  EXTRA b iy hl  left by 1...
        EX      AF,AF'
        ADD     IY,IY
        EX      AF,AF'
        JR      NC,DIV9
        INC     IY
.DIV9   EX      AF,AF'
        RL      B
        LD      A,(EXTRA)
        RLA
        LD      (EXTRA),A  ;...end of  EXTRA b iy hl  shifting
        LD      A,C     ;test  c ix de...
        OR      D
        OR      E
        DEFB    $DD
        OR      H
        DEFB    $DD
        OR      L       ;...end of  c ix de  testing
        JR      NZ,DIV2 ;nz => dividend nonzero
        PUSH    HL
        LD      HL,FA+5
        DEC     (HL)
        POP     HL
        JR      NZ,DIV2
        ret		;overflow?
;        JR      OFLOW2
;
.DIV12  POP     IY
        JP      PACK2








		


