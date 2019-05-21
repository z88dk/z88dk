
SECTION	code_fp_math32
PUBLIC	l_f32_ne
EXTERN	m32_compare_callee


l_f32_ne:
	call	m32_compare_callee
	scf
	ret	nz
	ccf
	dec	hl
	ret
