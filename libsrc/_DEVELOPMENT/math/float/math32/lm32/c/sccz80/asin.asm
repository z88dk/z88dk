
	SECTION	code_fp_math32
	PUBLIC	asin
	EXTERN	_m32_asinf


asin:
	pop	bc
	pop	hl
	pop	de
	push	de
	push	hl
	push	bc
	jp	_m32_asinf
