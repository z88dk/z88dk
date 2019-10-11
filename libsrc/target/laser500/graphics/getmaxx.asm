
	SECTION	code_clib
	PUBLIC	getmaxx
	PUBLIC	_getmaxx

	EXTERN	__console_w
	EXTERN	__laser500_mode


getmaxx:
_getmaxx:
	ld	hl,319
	ld	a,(__laser500_mode)
	cp	2
	ret	z
	ld	a,(__console_w)
	add	a
	dec	a
	ld	l,a
	ld	h,0
	ret
