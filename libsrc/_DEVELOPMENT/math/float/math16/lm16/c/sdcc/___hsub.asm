
    SECTION code_fp_math16

    PUBLIC ___hsub
    PUBLIC _subf16

    EXTERN cm16_sdcc_sub

    defc ___hsub = cm16_sdcc_sub
    defc _subf16 = cm16_sdcc_sub
