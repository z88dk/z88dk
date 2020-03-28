;
;       Z88dk Generic Floating Point Math Library
;
;       Multiply fa y bc ix de
;
;       $Id: fmul_noaf.asm,v 1.4 2016-06-21 21:16:49 dom Exp $:


        SECTION code_fp
	PUBLIC	fmul

	EXTERN	sgn
	EXTERN	div14
	EXTERN	norm

	EXTERN	fa


.fmul   CALL    sgn
        RET     Z       ; z => accumulator has zero
        LD      L,0     ;"product" flag
        CALL    div14   ;find exponent of product
        LD      A,C  ;c' h'l' d'e' (multiplicand) = c ix de...
        PUSH    DE
        EXX
        LD      C,A
        POP     DE
        PUSH    IX
        POP     HL
        EXX             ;...end of multiplicand loading
        LD      BC,0    ; c ix de b (product) = 0...
        LD      D,B
        LD      E,B
        LD      IX,0
        LD      HL,norm ; push addr of normalize routine
        PUSH    HL
        LD      HL,MULLOOP      ; push addr of top of loop
        PUSH    HL      ; (5 iterations wanted,
        PUSH    HL      ; once per byte of fraction)
        PUSH    HL
        PUSH    HL
        LD      HL,fa   ;point to LSB
.MULLOOP LD     A,(HL)  ;get next byte of multiplier
        INC     HL
        OR      A
        JR      NZ,MUL2 ; z => next 8 bits of multiplier are 0
        LD      B,E     ;shift  c ix de b  right by 8...
        LD      E,D
        LD      D,IXL
        ;EX      AF,AF'
		PUSH    AF
        LD      A,IXH
        LD      IXL,A
        ;EX      AF,AF'
		POP     AF
        LD      IXH,C
        LD      C,A     ;...end of shifting
        RET             ;go to top of loop or NORM
;
.MUL2   PUSH    HL      ;save multiplier pointer
        EX      DE,HL
        LD      E,8     ;8 iterations (once per bit)
.MUL4   RRA             ;rotate a multiplier bit into cy
        LD      D,A
        LD      A,C
        JR      NC,MUL6 ; nc => no addition needed
        PUSH    HL      ; c ix hl (product)  +=
        EXX             ;       c' h'l' d'e' (multiplicand)
        EX      (SP),HL
        ADD     HL,DE
        EX      (SP),HL
        EX      DE,HL
        PUSH    IX
        EX      (SP),HL
        ADC     HL,DE
        EX      (SP),HL
        POP     IX
        EX      DE,HL
        ADC     A,C
        EXX
        POP     HL
;
.MUL6   RRA        ;shift  c ix hl b (product)  right by 1...
        LD      C,A
        LD      A,IXH
        RRA
        LD      IXH,A
        LD      A,IXL
        RRA
        LD      IXL,A
        RR      H
        RR      L
        RR      B               ;...end of shifting
        DEC     E
        LD      A,D
        JR      NZ,MUL4         ; z => 8 iterations complete
        EX      DE,HL
.MUL8   POP     HL              ;recover multiplier pointer
        RET                     ;go to top of loop or NORM


