;
;       Z88dk Generic Floating Point Math Library
;
;
;       $Id: dadd.asm,v 1.3 2016-06-21 21:16:49 dom Exp $:


        SECTION code_fp
	PUBLIC	dadd

	EXTERN	fadd

.dadd
	pop	hl
	pop	de
	pop	ix
	pop	bc
	push	hl
	jp	fadd
