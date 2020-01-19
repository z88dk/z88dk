
	SECTION	code_clib
	PUBLIC	getmaxx
	PUBLIC	_getmaxx

	EXTERN	__console_w


getmaxx:
_getmaxx:
	ld	a,(__console_w)
	add	a
	dec	a
	ld	l,a
	ld	h,0
	ret
