
        SECTION code_fp_mbf32

        PUBLIC  sin
        EXTERN  ___mbf32_setup_single
        EXTERN  ___mbf32_SIN
        EXTERN  ___mbf32_return
        EXTERN	msbios

sin:
    call    ___mbf32_setup_single
IF __CPU_INTEL__ || __CPU_GBZ80__
    call    ___mbf32_SIN
ELSE
    ld      ix,___mbf32_SIN
    call    msbios
ENDIF
    jp      ___mbf32_return
