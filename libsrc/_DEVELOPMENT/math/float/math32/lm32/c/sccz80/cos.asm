
	SECTION	code_fp_math32
	PUBLIC	cos
	EXTERN	_m32_cosf


cos:
	pop	bc
	pop	hl
	pop	de
	push	de
	push	hl
	push	bc
	jp	_m32_cosf
