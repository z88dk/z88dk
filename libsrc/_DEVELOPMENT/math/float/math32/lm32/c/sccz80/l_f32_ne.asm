
SECTION	code_fp_math32
PUBLIC	l_f32_ne
EXTERN	l_f32_compare


l_f32_ne:
	call	l_f32_compare
	scf
	ret	nz
	ccf
	dec	hl
	ret
