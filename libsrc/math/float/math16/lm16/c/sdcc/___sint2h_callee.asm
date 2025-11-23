
    SECTION code_fp_math16

    PUBLIC ___sint2h_callee
    PUBLIC _f16_i16_fastcall

    EXTERN cm16_sdcc___sint2h_callee
    EXTERN cm16_sdcc___sint2h_fastcall

    defc ___sint2h_callee = cm16_sdcc___sint2h_callee
    defc _f16_i16_fastcall = cm16_sdcc___sint2h_fastcall
