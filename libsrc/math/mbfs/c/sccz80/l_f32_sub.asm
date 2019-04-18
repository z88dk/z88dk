
	SECTION	code_fp_mbfs

	PUBLIC	l_f32_sub
	EXTERN	fp_setup_arith
	EXTERN	SUBCDE
	EXTERN	fp_return


l_f32_sub:
	call	fp_setup_arith
	call	SUBCDE
	jp	fp_return


