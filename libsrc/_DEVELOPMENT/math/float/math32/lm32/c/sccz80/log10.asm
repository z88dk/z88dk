
	SECTION	code_fp_math32
	PUBLIC	log10
	EXTERN	_m32_log10f


log10:
	pop	bc
	pop	hl
	pop	de
	push	de
	push	hl
	push	bc
	jp	_m32_log10f
