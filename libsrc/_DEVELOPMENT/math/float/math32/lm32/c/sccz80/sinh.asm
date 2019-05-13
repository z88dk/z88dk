
	SECTION	code_fp_math32
	PUBLIC	sinh
	EXTERN	_m32_sinhf


sinh:
	pop	bc
	pop	hl
	pop	de
	push	de
	push	hl
	push	bc
	jp	_m32_sinhf
