
	SECTION	code_fp_math32
	PUBLIC	tanh
	EXTERN	_m32_tanhf


tanh:
	pop	bc
	pop	hl
	pop	de
	push	de
	push	hl
	push	bc
	jp	_m32_tanhf
