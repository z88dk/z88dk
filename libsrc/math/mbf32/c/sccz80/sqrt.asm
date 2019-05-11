
        SECTION code_fp_mbf32

        PUBLIC  sqrt
        EXTERN  ___mbf32_setup_single
        EXTERN  ___mbf32_SQR
        EXTERN  ___mbf32_return
	EXTERN	msbios

sqrt:
	call	___mbf32_setup_single
	ld	ix,___mbf32_SQR
	call	msbios
	jp	___mbf32_return
