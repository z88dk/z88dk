
    SECTION code_fp_math16

    PUBLIC ___hdiv_callee
    PUBLIC _m16_div_callee

    EXTERN cm16_sdcc_div_callee

    defc ___hdiv_callee = cm16_sdcc_div_callee
    defc _m16_div_callee = cm16_sdcc_div_callee
