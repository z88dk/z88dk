
    SECTION code_fp_math16

    PUBLIC ___hdiv
    PUBLIC _f16_div

    EXTERN cm16_sdcc_div

    defc ___hdiv = cm16_sdcc_div
    defc _f16_div = cm16_sdcc_div
