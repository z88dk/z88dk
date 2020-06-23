
    SECTION code_fp_math16

    PUBLIC ___hdiv_callee
    PUBLIC _divf16_callee

    EXTERN cm16_sdcc_div_callee

    defc ___hdiv_callee = cm16_sdcc_div_callee
    defc _divf16_callee = cm16_sdcc_div_callee
