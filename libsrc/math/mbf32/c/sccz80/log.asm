
        SECTION code_fp_mbf32

        PUBLIC  log
        EXTERN  ___mbf32_setup_single
        EXTERN  ___mbf32_LOG
        EXTERN  ___mbf32_return
	EXTERN	msbios

log:
    call    ___mbf32_setup_single
IF __CPU_INTEL__ || __CPU_GBZ80__
    call    ___mbf32_LOG
ELSE
    ld      ix,___mbf32_LOG
    call    msbios
ENDIF
    jp      ___mbf32_return
