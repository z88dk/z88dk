
        SECTION code_fp_mbf32

        PUBLIC  fabs
        EXTERN  ___mbf32_setup_single
        EXTERN  ___mbf32_ABS
        EXTERN  ___mbf32_return
	EXTERN	msbios

fabs:
	call	___mbf32_setup_single
	ld	ix,___mbf32_ABS
	call	msbios
	jp	___mbf32_return
