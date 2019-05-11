
        SECTION code_fp_mbf32

        PUBLIC  atan
        EXTERN  ___mbf32_setup_single
        EXTERN  ___mbf32_ATN
        EXTERN  ___mbf32_return
	EXTERN	msbios

atan:
	call	___mbf32_setup_single
	ld	ix,___mbf32_ATN
	call	msbios
	jp	___mbf32_return
