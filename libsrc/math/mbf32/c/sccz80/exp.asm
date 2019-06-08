
        SECTION code_fp_mbf32

        PUBLIC  exp
        EXTERN  ___mbf32_setup_single
        EXTERN  ___mbf32_EXP
        EXTERN  ___mbf32_return
	EXTERN	msbios

exp:
	call	___mbf32_setup_single
	ld	ix,___mbf32_EXP
	call	msbios
	jp	___mbf32_return
