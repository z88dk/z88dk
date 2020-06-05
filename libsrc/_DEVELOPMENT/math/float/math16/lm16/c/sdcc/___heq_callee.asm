
    SECTION code_fp_math16

    PUBLIC ___heq_callee
    PUBLIC _m16_isunordered_callee

    EXTERN cm16_sdcc___eq_callee

    defc ___heq_callee = cm16_sdcc___eq_callee
    defc _m16_isunordered_callee = cm16_sdcc___eq_callee
