;
;	written by Waleed Hasan
;
;	$Id: setpixsave.asm,v 1.2 2003-03-13 15:02:10 dom Exp $

	XLIB	setpixsave
	LIB	setpix
	
.setpixsave

	push	hl
	push	de
	push	bc
	
	call	setpix

	pop	bc
	pop	de
	pop	hl
	
	ret
