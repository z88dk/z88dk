
        SECTION code_fp_mbf32

        PUBLIC  pow
        EXTERN  ___mbf32_setup_two
        EXTERN  ___mbf32_POW
        EXTERN  ___mbf32_return
        EXTERN	msbios

pow:
    call    ___mbf32_setup_two
IF __CPU_INTEL__ || __CPU_GBZ80__
    call    ___mbf32_POW
ELSE
    ld      ix,___mbf32_POW
    call    msbios
ENDIF
    jp      ___mbf32_return
