
	SECTION	code_clib
	PUBLIC	getmaxx
	PUBLIC	_getmaxx

	EXTERN	__console_w


getmaxx:
_getmaxx:
	ld	hl,(__console_w)
	ld	h,0
	dec	hl
	ret
