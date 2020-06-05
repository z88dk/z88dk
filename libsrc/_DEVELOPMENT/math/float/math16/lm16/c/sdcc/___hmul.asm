
    SECTION code_fp_math16

    PUBLIC ___hmul
    PUBLIC _m16_mul

    EXTERN cm16_sdcc_mul

    defc ___hmul = cm16_sdcc_mul
    defc _m16_mul = cm16_sdcc_mul
