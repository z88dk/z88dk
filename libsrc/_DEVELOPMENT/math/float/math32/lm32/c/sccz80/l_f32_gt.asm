
SECTION	code_fp_math32
PUBLIC	l_f32_gt
EXTERN	m32_compare_callee


l_f32_gt:
	call	m32_compare_callee
	jr	z,gt1
	ccf
	ret	c
gt1:
	dec	hl
	ret
