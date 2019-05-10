
SECTION	code_fp_math32
PUBLIC	l_f32_lt
EXTERN	l_f32_compare


l_f32_lt:
	call	l_f32_compare
	ret	c
	dec	hl
	ret
