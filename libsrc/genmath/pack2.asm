;
;       Z88dk Generic Floating Point Math Library
;
;
;       $Id: pack2.asm,v 1.1 2002-01-21 20:35:22 dom Exp $:

		XLIB	pack2

		LIB	ldfabc
		LIB	incr

		XREF	fa
		

.PACK2  LD      HL,FA+5 ;round c ix de b to 40 bits
        OR      A
        CALL    M,INCR
        LD      B,(HL)  ;load exponent
        INC     HL
        LD      A,(HL)  ;recover sign
        AND     $80     ;mask out all but sign
        XOR     C       ;add to high
        LD      C,A     ;   order byte
        JP      LDFABC  ;place answer in FA
