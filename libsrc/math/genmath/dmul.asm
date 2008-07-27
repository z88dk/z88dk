;
;       Z88dk Generic Floating Point Math Library
;
;	
;
;       $Id: dmul.asm,v 1.1 2008-07-27 21:44:57 aralbrec Exp $:


		XLIB	dmul

		LIB	fmul

.dmul
	pop	hl	;ret address 
	pop	de
	pop	ix
	pop	bc	
	push	hl
	jp	fmul
