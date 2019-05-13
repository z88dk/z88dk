
	SECTION	code_fp_math32
	PUBLIC	cosh
	EXTERN	_m32_coshf


cosh:
	pop	bc
	pop	hl
	pop	de
	push	de
	push	hl
	push	bc
	jp	_m32_coshf
