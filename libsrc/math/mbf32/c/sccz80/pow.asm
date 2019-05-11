
        SECTION code_fp_mbf32

        PUBLIC  pow
        EXTERN  ___mbf32_setup_two
        EXTERN  ___mbf32_POW
        EXTERN  ___mbf32_return
	EXTERN	msbios

pow:
	call	___mbf32_setup_two
	ld	ix,___mbf32_POW
	call	msbios
	jp	___mbf32_return
