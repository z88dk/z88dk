
	SECTION	code_fp_mbfs

	PUBLIC	l_f32_mul
	EXTERN	fp_setup_arith
	EXTERN	FPMULT
	EXTERN	fp_return


l_f32_mul:
	call	fp_setup_arith
	call	FPMULT
	jp	fp_return


