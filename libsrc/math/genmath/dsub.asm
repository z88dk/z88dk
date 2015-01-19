;
;       Z88dk Generic Floating Point Math Library
;
;
;       $Id: dsub.asm,v 1.2 2015-01-19 01:32:56 pauloscustodio Exp $:


		PUBLIC	dsub

		EXTERN	minusfa
		EXTERN	fadd

.dsub
	call minusfa
	pop	hl	;return address
	pop	de
	pop	ix
	pop	bc	
	push	hl
	jp	fadd

