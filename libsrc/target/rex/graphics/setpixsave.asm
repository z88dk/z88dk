;
;	written by Waleed Hasan
;
;	$Id: setpixsave.asm,v 1.3 2015-01-19 01:33:06 pauloscustodio Exp $

	PUBLIC	setpixsave
	EXTERN	setpix
	
.setpixsave

	push	hl
	push	de
	push	bc
	
	call	setpix

	pop	bc
	pop	de
	pop	hl
	
	ret
