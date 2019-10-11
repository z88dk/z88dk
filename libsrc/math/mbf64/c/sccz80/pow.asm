        SECTION code_fp_mbf64

        PUBLIC  pow
        EXTERN  ___mbf64_setup_two_single
        EXTERN  ___mbf32_POW
        EXTERN  ___mbf64_return_single
        EXTERN  msbios

pow:
        call    ___mbf64_setup_two_single
        ld      ix,___mbf32_POW
        call    msbios
        jp      ___mbf64_return_single
