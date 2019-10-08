        SECTION code_fp_mbf64

        PUBLIC  log10
        EXTERN  ___mbf64_setup_single
        EXTERN  ___mbf32_LOG
        EXTERN  ___mbf32_DVBCDE
        EXTERN  ___mbf32_FPREG
        EXTERN  ___mbf64_return_single
        EXTERN  msbios

log10:
        call    ___mbf64_setup_single
        ld      ix,___mbf32_LOG
        call    msbios
        ld      de,(___mbf32_FPREG)
        ld      bc,(___mbf32_FPREG + 2)
        ld      hl,0x5d8e               ;ln(10)
        ld      (___mbf32_FPREG),hl
        ld      hl,0x8213
        ld      (___mbf32_FPREG + 2),hl
        ld      ix,___mbf32_DVBCDE
        call    msbios
        jp      ___mbf64_return_single
