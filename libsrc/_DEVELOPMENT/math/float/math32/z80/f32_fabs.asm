
SECTION code_fp_math32
PUBLIC  m32_fabs

m32_fabs:
	pop	bc
	pop	hl
	pop	de
	push	de
	push	hl
	push	bc
	res	7,d
	ret
