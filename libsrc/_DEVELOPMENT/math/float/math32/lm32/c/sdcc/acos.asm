
	SECTION	code_fp_math32
	PUBLIC	_acos
	EXTERN	_m32_acosf


_acos:
	pop	bc
	pop	hl
	pop	de
	push	de
	push	hl
	push	bc
	jp	_m32_acosf
