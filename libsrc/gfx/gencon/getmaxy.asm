
	SECTION	code_clib
	PUBLIC	getmaxy
	PUBLIC	_getmaxy

	EXTERN	__console_h


getmaxy:
_getmaxy:
	ld	a,(__console_h)
	add	a
	dec	a
	ld	l,a
	ld	h,0
	ret
