
	SECTION	code_fp_mbf32

	PUBLIC	l_f32_sub
	EXTERN	___mbf32_setup_arith
	EXTERN	___mbf32_SUBCDE
	EXTERN	___mbf32_return
	EXTERN	msbios


l_f32_sub:
	call	___mbf32_setup_arith
IF __CPU_INTEL__ || __CPU_GBZ80__
	call	___mbf32_SUBCDE
ELSE
	ld	ix,___mbf32_SUBCDE
	call	msbios
ENDIF
	jp	___mbf32_return


