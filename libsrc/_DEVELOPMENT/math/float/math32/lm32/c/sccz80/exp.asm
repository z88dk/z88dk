
	SECTION	code_fp_math32
	PUBLIC	exp
	EXTERN	_m32_expf


exp:
	pop	bc
	pop	hl
	pop	de
	push	de
	push	hl
	push	bc
	jp	_m32_expf
