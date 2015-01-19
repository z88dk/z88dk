;
;       Z88dk Generic Floating Point Math Library
;
;
;       $Id: pack.asm,v 1.3 2015-01-19 01:32:56 pauloscustodio Exp $:

		PUBLIC	pack

		EXTERN	pack2

		

.pack   LD      A,B
	jp	pack2
