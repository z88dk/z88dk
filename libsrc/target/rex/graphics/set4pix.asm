;
;	written by Waleed Hasan
;
;	$Id: set4pix.asm,v 1.3 2015-01-19 01:33:06 pauloscustodio Exp $

	PUBLIC	set4pix
	EXTERN	setpixsave
	
.set4pix
	ld	a,b
	add	a,h
	ld	d,a
	ld	a,c
	add	a,l
	ld	e,a
	call	setpixsave		;PIX(xc+x,yc+y)

	ld	a,b
	sub	h
	ld	d,a
	call	setpixsave		;PIX(xc-x,yc+y)

	ld	a,c
	sub	l
	ld	e,a
	call	setpixsave		;PIX(xc-x,yc-y)

	ld	a,b
	add	a,h
	ld	d,a
	call	setpixsave		;PIX(xc+x,yc-y)
	
	ret

