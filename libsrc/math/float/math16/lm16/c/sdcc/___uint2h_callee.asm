
    SECTION code_fp_math16

    PUBLIC ___uint2h_callee
    PUBLIC _f16_u16_fastcall

    EXTERN cm16_sdcc___uint2h_callee
    EXTERN cm16_sdcc___uint2h_fastcall

    defc ___uint2h_callee = cm16_sdcc___uint2h_callee
    defc _f16_u16_fastcall = cm16_sdcc___uint2h_fastcall
