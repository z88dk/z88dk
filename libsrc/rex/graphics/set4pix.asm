;
;	written by Waleed Hasan
;
;	$Id: set4pix.asm,v 1.2 2003-03-13 15:02:09 dom Exp $

	XLIB	set4pix
	LIB	setpixsave
	
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

