;
;       Z88dk Generic Floating Point Math Library
;
;
;       $Id: mgm_dadd.asm,v 1.1 2015-03-27 06:03:28 aralbrec Exp $:


		PUBLIC	dadd

		EXTERN	fadd

.dadd
	pop	hl
	pop	de
	pop	ix
	pop	bc
	push	hl
	jp	fadd
