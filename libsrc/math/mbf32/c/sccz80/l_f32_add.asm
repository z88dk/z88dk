
	SECTION	code_fp_mbf32

	PUBLIC	l_f32_add
	EXTERN	___mbf32_setup_arith
	EXTERN	___mbf32_FPADD
	EXTERN	___mbf32_return
	EXTERN	msbios


l_f32_add:
	call	___mbf32_setup_arith
	ld	ix,___mbf32_FPADD
	call	msbios
	jp	___mbf32_return


