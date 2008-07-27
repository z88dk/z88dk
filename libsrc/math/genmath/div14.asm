;
;       Z88dk Generic Floating Point Math Library
;
;       Find exponent for product (l=0) or quotient(l=ff)
;
;       $Id: div14.asm,v 1.1 2008-07-27 21:44:57 aralbrec Exp $:


		XLIB	div14

		LIB	unpack
		LIB	norm4

		XREF	FA

.DIV14  LD      A,B
        OR      A
        JR      Z,DIV20
        LD      A,L     ;get product/quotient flag
        LD      HL,FA+5
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
        CALL    UNPACK  ;restore hidden bits & compare signs
        LD      (HL),A  ;save difference of signs
        DEC     HL      ;point to MSB of fraction
        RET
.div14_1
	pop	hl
	ret

.div18	or	a
.div20	pop	hl
	jp	p,norm4
	ret		;jp oflow
