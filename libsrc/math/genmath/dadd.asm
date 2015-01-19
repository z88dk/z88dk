;
;       Z88dk Generic Floating Point Math Library
;
;
;       $Id: dadd.asm,v 1.2 2015-01-19 01:32:56 pauloscustodio Exp $:


		PUBLIC	dadd

		EXTERN	fadd

.dadd
	pop	hl
	pop	de
	pop	ix
	pop	bc
	push	hl
	jp	fadd
