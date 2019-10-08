
	SECTION	code_clib
	PUBLIC	getmaxy
	PUBLIC	_getmaxy

	EXTERN	__console_h
	EXTERN	__laser500_mode


getmaxy:
_getmaxy:
	ld	hl,191
	ld	a,(__laser500_mode)
	cp	2
	ret	z
	ld	a,(__console_h)
	add	a
	dec	a
	ld	l,a
	ld	h,0
	ret
