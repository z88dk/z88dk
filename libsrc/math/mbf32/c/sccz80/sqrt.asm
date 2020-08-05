
        SECTION code_fp_mbf32

        PUBLIC  sqrt
        EXTERN  ___mbf32_setup_single
        EXTERN  ___mbf32_SQR
        EXTERN  ___mbf32_return
	EXTERN	msbios

sqrt:
    call    ___mbf32_setup_single
IF __CPU_INTEL__ || __CPU_GBZ80__
    call    ___mbf32_SQR
ELSE
    ld      ix,___mbf32_SQR
    call    msbios
ENDIF
    jp      ___mbf32_return
