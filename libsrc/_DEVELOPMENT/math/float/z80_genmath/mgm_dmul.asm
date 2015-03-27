;
;       Z88dk Generic Floating Point Math Library
;
;	
;
;       $Id: mgm_dmul.asm,v 1.1 2015-03-27 06:03:28 aralbrec Exp $:


		PUBLIC	dmul

		EXTERN	fmul

.dmul
	pop	hl	;ret address 
	pop	de
	pop	ix
	pop	bc	
	push	hl
	jp	fmul
