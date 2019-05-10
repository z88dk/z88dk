
SECTION	code_fp_math32
PUBLIC	l_f32_eq
EXTERN	l_f32_compare


l_f32_eq:
	call	l_f32_compare
	scf
	ret	z
	ccf
	dec	hl
	ret
