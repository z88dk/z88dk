
	SECTION	code_fp_mbf32

	PUBLIC	l_f32_mul
	EXTERN	___mbf32_setup_arith
	EXTERN	___mbf32_FPMULT
	EXTERN	___mbf32_return
	EXTERN	msbios


l_f32_mul:
	call	___mbf32_setup_arith
	ld	ix,___mbf32_FPMULT
	call	msbios
	jp	___mbf32_return


