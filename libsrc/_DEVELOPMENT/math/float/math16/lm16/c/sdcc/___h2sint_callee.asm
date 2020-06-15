
    SECTION code_fp_math16

    PUBLIC ___h2sint_callee
    PUBLIC _i16_f16_fastcall

    EXTERN cm16_sdcc___h2sint_callee
    EXTERN cm16_sdcc___h2sint_fastcall

    defc ___h2sint_callee = cm16_sdcc___h2sint_callee
    defc _i16_f16_fastcall = cm16_sdcc___h2sint_fastcall
