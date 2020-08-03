
        SECTION code_fp_mbf32

        PUBLIC  tan
        EXTERN  ___mbf32_setup_single
        EXTERN  ___mbf32_TAN
        EXTERN  ___mbf32_return
        EXTERN	msbios

tan:
    call    ___mbf32_setup_single
IF __CPU_INTEL__ || __CPU_GBZ80__
    call    ___mbf32_TAN
ELSE
    ld      ix,___mbf32_TAN
    call    msbios
ENDIF
    jp      ___mbf32_return
