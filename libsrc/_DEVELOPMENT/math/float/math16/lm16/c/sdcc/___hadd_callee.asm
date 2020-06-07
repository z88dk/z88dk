
    SECTION code_fp_math16

    PUBLIC ___hadd_callee
    PUBLIC _m16_add_callee

    EXTERN cm16_sdcc_add_callee

    defc ___hadd_callee = cm16_sdcc_add_callee
    defc _m16_add_callee = cm16_sdcc_add_callee
