
    SECTION code_fp_math16

    PUBLIC ___h2uint_callee
    PUBLIC _u16_f16_fastcall

    EXTERN cm16_sdcc___h2uint_callee
    EXTERN cm16_sdcc___h2uint_fastcall

    defc ___h2uint_callee = cm16_sdcc___h2uint_callee
    defc _u16_f16_fastcall = cm16_sdcc___h2uint_fastcall
