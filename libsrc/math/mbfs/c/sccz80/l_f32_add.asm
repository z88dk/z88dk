
	SECTION	code_fp_mbfs

	PUBLIC	l_f32_add
	EXTERN	fp_setup_arith
	EXTERN	FPADD
	EXTERN	fp_return


l_f32_add:
	call	fp_setup_arith
	call	FPADD
	jp	fp_return


