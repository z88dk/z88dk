
    SECTION code_fp_math16

    PUBLIC ___hsub_callee
    PUBLIC _f16_sub_callee

    EXTERN cm16_sdcc_sub_callee

    defc ___hsub_callee = cm16_sdcc_sub_callee
    defc _f16_sub_callee = cm16_sdcc_sub_callee
