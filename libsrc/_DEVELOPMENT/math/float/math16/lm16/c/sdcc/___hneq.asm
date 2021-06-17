
    SECTION code_fp_math16

    PUBLIC ___hneq
    PUBLIC _isnotequalf16

    EXTERN cm16_sdcc___neq

    defc ___hneq = cm16_sdcc___neq
    defc _isnotequalf16 = cm16_sdcc___neq

