
    SECTION code_fp_math16

    PUBLIC ___hmul_callee
    PUBLIC _mulf16_callee

    EXTERN cm16_sdcc_mul_callee

    defc ___hmul_callee = cm16_sdcc_mul_callee
    defc _mulf16_callee = cm16_sdcc_mul_callee
