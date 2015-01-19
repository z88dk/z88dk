;
;       Z88dk Generic Floating Point Math Library
;
;	
;
;       $Id: ddiv.asm,v 1.2 2015-01-19 01:32:56 pauloscustodio Exp $:


		PUBLIC	ddiv

		EXTERN	fdiv

.ddiv
	pop	hl	;ret address 
	pop	de
	pop	ix
	pop	bc	
	push	hl
	jp	fdiv
