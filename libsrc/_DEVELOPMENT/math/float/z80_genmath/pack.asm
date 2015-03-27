;
;       Z88dk Generic Floating Point Math Library
;
;
;       $Id: pack.asm,v 1.1 2015-03-27 06:03:29 aralbrec Exp $:

		PUBLIC	pack

		EXTERN	pack2

		

.pack   LD      A,B
	jp	pack2
