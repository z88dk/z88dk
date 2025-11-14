
    SECTION code_fp_math16

    PUBLIC ___heq_callee
    PUBLIC _isunorderedf16_callee

    EXTERN cm16_sdcc___eq_callee

    defc ___heq_callee = cm16_sdcc___eq_callee
    defc _isunorderedf16_callee = cm16_sdcc___eq_callee
