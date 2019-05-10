
SECTION	code_fp_math32
PUBLIC	l_f32_gt
EXTERN	l_f32_compare


l_f32_gt:
	call	l_f32_compare
	jr	z,gt1
	ccf
	ret	nc
gt1:
	dec	hl
	ret
