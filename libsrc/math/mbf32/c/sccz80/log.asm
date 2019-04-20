
        SECTION code_fp_mbf32

        PUBLIC  log
        EXTERN  ___mbf32_setup_single
        EXTERN  ___mbf32_LOG
        EXTERN  ___mbf32_return
	EXTERN	msbios

log:
	call	___mbf32_setup_single
	ld	ix,___mbf32_LOG
	call	msbios
	jp	___mbf32_return
