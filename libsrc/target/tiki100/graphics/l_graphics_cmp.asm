; We need a copy of this routine in himem 

	SECTION		code_graphics
	PUBLIC		l_graphics_cmp

.l_graphics_cmp
	ld	a,h
	add	$80
	ld	b,a
	ld	a,d
	add	$80
	cp	b
	ret	nz
	ld	a,e
	cp	l
	ret
