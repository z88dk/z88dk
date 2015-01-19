;
;       Z88dk Generic Floating Point Math Library
;
;
;       $Id: fsub.asm,v 1.2 2015-01-19 01:32:56 pauloscustodio Exp $:


		PUBLIC	fsub

		EXTERN	minusfa
		EXTERN	fadd

.fsub
	call minusfa
	jp	fadd

