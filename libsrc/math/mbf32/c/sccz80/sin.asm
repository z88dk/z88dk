
        SECTION code_fp_mbf32

        PUBLIC  sin
        EXTERN  ___mbf32_setup_single
        EXTERN  ___mbf32_SIN
        EXTERN  ___mbf32_return
	EXTERN	msbios

sin:
	call	___mbf32_setup_single
	ld	ix,___mbf32_SIN
	call	msbios
	jp	___mbf32_return
