
	SECTION	code_fp_math32
	PUBLIC	_asin
	EXTERN	_m32_asinf


_asin:
	pop	bc
	pop	hl
	pop	de
	push	de
	push	hl
	push	bc
	jp	_m32_asinf
