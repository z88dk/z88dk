;
;	written by Waleed Hasan
;

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
