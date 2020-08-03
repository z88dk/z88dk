
	SECTION	code_fp_mbf32

	PUBLIC	l_f32_mul
	EXTERN	___mbf32_setup_arith
	EXTERN	___mbf32_FPMULT
	EXTERN	___mbf32_return
	EXTERN	msbios


l_f32_mul:
	call	___mbf32_setup_arith
IF __CPU_INTEL__ || __CPU_GBZ80__
	call	___mbf32_FPMULT
ELSE
	ld	ix,___mbf32_FPMULT
	call	msbios
ENDIF
	jp	___mbf32_return


