
	SECTION	code_fp_math32
	PUBLIC	_sinh
	EXTERN	_m32_sinhf


_sinh:
	pop	bc
	pop	hl
	pop	de
	push	de
	push	hl
	push	bc
	jp	_m32_sinhf
