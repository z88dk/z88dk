
	SECTION	code_fp_math32
	PUBLIC	_sin
	EXTERN	_m32_sinf


_sin:
	pop	bc
	pop	hl
	pop	de
	push	de
	push	hl
	push	bc
	jp	_m32_sinf
