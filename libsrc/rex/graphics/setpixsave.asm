;
;	written by Waleed Hasan
;

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
