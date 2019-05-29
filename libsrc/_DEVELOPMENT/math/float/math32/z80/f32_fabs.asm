
SECTION code_fp_math32
PUBLIC  m32_fabs
PUBLIC  m32_fabs_fastcall
PUBLIC _m32_fabsf


.m32_fabs
	pop	bc
	pop	hl
	pop	de
	push	de
	push	hl
	push	bc

._m32_fabsf
.m32_fabs_fastcall
	res	7,d
	ret
	res	7,d
	ret
