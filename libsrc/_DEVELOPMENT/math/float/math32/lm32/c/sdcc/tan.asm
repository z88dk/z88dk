
	SECTION	code_fp_math32
	PUBLIC	_tan
	EXTERN	_m32_tanf


_tan:
	pop	bc
	pop	hl
	pop	de
	push	de
	push	hl
	push	bc
	jp	_m32_tanf
