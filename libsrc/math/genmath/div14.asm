;
;       Z88dk Generic Floating Point Math Library
;
;       Find exponent for product (l=0) or quotient(l=ff)
;
;       $Id: div14.asm,v 1.3 2015-01-19 01:32:56 pauloscustodio Exp $:


		PUBLIC	div14

		EXTERN	unpack
		EXTERN	norm4

		EXTERN	fa

.div14  LD      A,B
        OR      A
        JR      Z,DIV20
        LD      A,L     ;get product/quotient flag
        LD      HL,fa+5
        XOR     (HL)    ;get +-FA exponent
        ADD     A,B     ;find and...
        LD      B,A     ;...load new exponent
        RRA
        XOR     B
        LD      A,B
        JP      P,DIV18
        ADD     A,$80
        LD      (HL),A
        Jr      Z,div14_1
        CALL    unpack  ;restore hidden bits & compare signs
        LD      (HL),A  ;save difference of signs
        DEC     HL      ;point to MSB of fraction
        RET
.div14_1
	pop	hl
	ret

.DIV18	or	a
.DIV20	pop	hl
        jp  p,norm4
        ret            ;jp oflow
