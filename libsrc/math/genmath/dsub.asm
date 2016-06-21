;
;       Z88dk Generic Floating Point Math Library
;
;
;       $Id: dsub.asm,v 1.3 2016-06-21 21:16:49 dom Exp $:


        SECTION code_fp
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

