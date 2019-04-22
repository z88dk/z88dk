        SECTION code_fp_mbf64

        PUBLIC  exp
        EXTERN  ___mbf64_setup_two_single
        EXTERN  ___mbf32_EXP
        EXTERN  ___mbf64_return_single
        EXTERN  msbios

exp:
        call    ___mbf64_setup_two_single
        ld      ix,___mbf32_EXP
        call    msbios
        jp      ___mbf64_return_single
