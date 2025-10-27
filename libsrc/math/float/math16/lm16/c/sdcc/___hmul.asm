
    SECTION code_fp_math16

    PUBLIC ___hmul
    PUBLIC _mulf16

    EXTERN cm16_sdcc_mul

    defc ___hmul = cm16_sdcc_mul
    defc _mulf16 = cm16_sdcc_mul
