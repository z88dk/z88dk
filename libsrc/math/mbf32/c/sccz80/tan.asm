
        SECTION code_fp_mbf32

        PUBLIC  tan
        EXTERN  ___mbf32_setup_single
        EXTERN  ___mbf32_TAN
        EXTERN  ___mbf32_return
	EXTERN	msbios

tan:
	call	___mbf32_setup_single
	ld	ix,___mbf32_TAN
	call	msbios
	jp	___mbf32_return
