
SECTION	code_fp_math32
PUBLIC	l_f32_ge
EXTERN	l_f32_compare


l_f32_ge:
	call	l_f32_compare
	ccf
	ret	nc
	scf
	ret	z
	ccf
	dec	hl
	ret
