
SECTION	code_fp_math32
PUBLIC	l_f32_le
EXTERN	m32_compare_callee


l_f32_le:
	call	m32_compare_callee
	ret	c
	scf
	ret	z
	ccf
	dec	hl
	ret
