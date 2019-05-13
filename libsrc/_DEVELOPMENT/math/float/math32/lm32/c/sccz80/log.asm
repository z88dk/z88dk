
	SECTION	code_fp_math32
	PUBLIC	log
	EXTERN	_m32_logf


log:
	pop	bc
	pop	hl
	pop	de
	push	de
	push	hl
	push	bc
	jp	_m32_logf
