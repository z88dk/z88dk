
    SECTION code_fp_math16

    PUBLIC ___hmul
    PUBLIC _f16_mul

    EXTERN cm16_sdcc_mul

    defc ___hmul = cm16_sdcc_mul
    defc _f16_mul = cm16_sdcc_mul
