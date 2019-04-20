
	SECTION	code_fp_mbf32

	PUBLIC	l_f32_sub
	EXTERN	___mbf32_setup_arith
	EXTERN	___mbf32_SUBCDE
	EXTERN	___mbf32_return
	EXTERN	msbios


l_f32_sub:
	call	___mbf32_setup_arith
	ld	ix,___mbf32_SUBCDE
	call	msbios
	jp	___mbf32_return


