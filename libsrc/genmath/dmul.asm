;
;       Z88dk Generic Floating Point Math Library
;
;	
;
;       $Id: dmul.asm,v 1.1 2002-01-21 20:35:22 dom Exp $:


		XLIB	dmul

		LIB	fmul

.dmul
	pop	hl	;ret address 
	pop	de
	pop	ix
	pop	bc	
	push	hl
	jp	fmul
