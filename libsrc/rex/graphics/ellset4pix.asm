;
;	written by Waleed Hasan
;
;	$Id: ellset4pix.asm,v 1.2 2003-03-13 15:02:09 dom Exp $

	XLIB	ellset4pix
	LIB	set4pix
	
.ellset4pix
	ld	hl,32
	add	hl,sp

	ld	d,(hl)			;x

	dec	hl
	dec	hl
	ld	e,(hl)			;y

	ld	hl,50
	add	hl,sp

	ld	b,(hl)			;B=xc
	dec	hl
	dec	hl
	ld	c,(hl)			;C=yc

	ex	de,hl			;H=x
					;L=y
	jp	set4pix
