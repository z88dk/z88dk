
    SECTION code_fp_math16

    PUBLIC ___hdiv
    PUBLIC _divf16

    EXTERN cm16_sdcc_div

    defc ___hdiv = cm16_sdcc_div
    defc _divf16 = cm16_sdcc_div
