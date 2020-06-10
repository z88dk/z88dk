
    SECTION code_fp_math16

    PUBLIC ___hneq_callee
    PUBLIC _f16_isnotequal_callee

    EXTERN cm16_sdcc___neq_callee

    defc ___hneq_callee = cm16_sdcc___neq_callee
    defc _f16_isnotequal_callee = cm16_sdcc___neq_callee

