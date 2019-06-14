
SECTION	code_fp_math32
PUBLIC	l_f32_eq
EXTERN	m32_compare_callee


l_f32_eq:
	call	m32_compare_callee
	scf
	ret	z
	ccf
	dec	hl
	ret
