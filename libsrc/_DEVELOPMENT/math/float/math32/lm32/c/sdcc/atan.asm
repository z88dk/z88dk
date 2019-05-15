
	SECTION	code_fp_math32
	PUBLIC	_atan
	EXTERN	_m32_atanf


_atan:
	pop	bc
	pop	hl
	pop	de
	push	de
	push	hl
	push	bc
	jp	_m32_atanf
