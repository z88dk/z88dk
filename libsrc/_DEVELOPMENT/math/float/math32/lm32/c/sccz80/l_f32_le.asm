
SECTION	code_fp_math32
PUBLIC	l_f32_le
EXTERN	l_f32_compare


l_f32_le:
	call	l_f32_compare
	ret	c
	scf
	ret	z
	ccf
	dec	hl
	ret
