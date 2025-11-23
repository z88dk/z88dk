
    SECTION code_fp_math16

    PUBLIC ___heq
    PUBLIC _isunorderedf16

    EXTERN cm16_sdcc___eq

    defc ___heq = cm16_sdcc___eq
    defc _isunorderedf16 = cm16_sdcc___eq
