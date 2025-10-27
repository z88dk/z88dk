
    SECTION code_fp_math16

    PUBLIC ___hneq_callee
    PUBLIC _isnotequalf16_callee

    EXTERN cm16_sdcc___neq_callee

    defc ___hneq_callee = cm16_sdcc___neq_callee
    defc _isnotequalf16_callee = cm16_sdcc___neq_callee

