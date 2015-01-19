;
;       Z88dk Generic Floating Point Math Library
;
;
;       $Id: pack2.asm,v 1.3 2015-01-19 01:32:56 pauloscustodio Exp $:

		PUBLIC	pack2

		EXTERN	ldfabc
		EXTERN	incr

		EXTERN	fa
		

.pack2  LD      HL,fa+5 ;round c ix de b to 40 bits
        OR      A
        CALL    M,incr
        LD      B,(HL)  ;load exponent
        INC     HL
        LD      A,(HL)  ;recover sign
        AND     $80     ;mask out all but sign
        XOR     C       ;add to high
        LD      C,A     ;   order byte
        JP      ldfabc  ;place answer in FA
