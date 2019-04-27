;
;       Z88dk Generic Floating Point Math Library
;
;
;       $Id: fsub.asm,v 1.3 2016-06-21 21:16:49 dom Exp $:

        SECTION code_fp
	PUBLIC	fsub

	EXTERN	minusfa
	EXTERN	fadd

.fsub
	call minusfa
	jp	fadd

