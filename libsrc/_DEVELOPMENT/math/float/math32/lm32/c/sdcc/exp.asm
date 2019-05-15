
	SECTION	code_fp_math32
	PUBLIC	_exp
	EXTERN	_m32_expf


_exp:
	pop	bc
	pop	hl
	pop	de
	push	de
	push	hl
	push	bc
	jp	_m32_expf
