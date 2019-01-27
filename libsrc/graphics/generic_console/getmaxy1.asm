
	SECTION	code_clib
	PUBLIC	getmaxy
	PUBLIC	_getmaxy

	EXTERN	__console_h


getmaxy:
_getmaxy:
	ld	hl,(__console_h)
	ld	h,0
	dec	hl
	ret
