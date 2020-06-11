
    SECTION code_fp_math16

    PUBLIC ___hgt_callee
    PUBLIC _f16_isgreater_callee

    EXTERN cm16_sdcc___gt_callee

    defc ___hgt_callee = cm16_sdcc___gt_callee
    defc _f16_isgreater_callee = cm16_sdcc___gt_callee
