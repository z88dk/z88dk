
    SECTION code_fp_math16

    PUBLIC ___hadd_callee
    PUBLIC _addf16_callee

    EXTERN cm16_sdcc_add_callee

    defc ___hadd_callee = cm16_sdcc_add_callee
    defc _addf16_callee = cm16_sdcc_add_callee
