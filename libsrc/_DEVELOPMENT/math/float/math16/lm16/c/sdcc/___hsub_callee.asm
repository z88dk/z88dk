
    SECTION code_fp_math16

    PUBLIC ___hsub_callee
    PUBLIC _subf16_callee

    EXTERN cm16_sdcc_sub_callee

    defc ___hsub_callee = cm16_sdcc_sub_callee
    defc _subf16_callee = cm16_sdcc_sub_callee
