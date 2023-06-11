
    SECTION code_fp_math16

    PUBLIC ___hlt
    PUBLIC _islessf16

    EXTERN cm16_sdcc___lt

    defc ___hlt = cm16_sdcc___lt
    defc _islessf16 = cm16_sdcc___lt
