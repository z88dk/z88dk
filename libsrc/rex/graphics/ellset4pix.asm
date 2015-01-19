;
;	written by Waleed Hasan
;
;	$Id: ellset4pix.asm,v 1.3 2015-01-19 01:33:06 pauloscustodio Exp $

	PUBLIC	ellset4pix
	EXTERN	set4pix
	
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
