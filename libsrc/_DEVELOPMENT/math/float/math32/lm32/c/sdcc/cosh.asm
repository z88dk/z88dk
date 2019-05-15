
	SECTION	code_fp_math32
	PUBLIC	_cosh
	EXTERN	_m32_coshf


_cosh:
	pop	bc
	pop	hl
	pop	de
	push	de
	push	hl
	push	bc
	jp	_m32_coshf
