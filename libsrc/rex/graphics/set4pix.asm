;
;	written by Waleed Hasan
;

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

