
    SECTION code_fp_math16

    PUBLIC ___hdiv
    PUBLIC _m16_div

    EXTERN cm16_sdcc_div

    defc ___hdiv = cm16_sdcc_div
    defc _m16_div = cm16_sdcc_div
