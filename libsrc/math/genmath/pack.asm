;
;       Z88dk Generic Floating Point Math Library
;
;
;       $Id: pack.asm,v 1.4 2016-06-21 21:16:49 dom Exp $:

        SECTION code_fp
	PUBLIC	pack

	EXTERN	pack2

		

.pack   LD      A,B
	jp	pack2
