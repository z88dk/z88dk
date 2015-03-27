;
;       Z88dk Generic Floating Point Math Library
;
;
;       $Id: mgm_fsub.asm,v 1.1 2015-03-27 06:03:29 aralbrec Exp $:


		PUBLIC	fsub

		EXTERN	minusfa
		EXTERN	fadd

.fsub
	call minusfa
	jp	fadd

