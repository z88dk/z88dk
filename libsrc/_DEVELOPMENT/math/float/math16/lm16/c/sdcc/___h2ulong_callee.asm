
    SECTION code_fp_math16

    PUBLIC ___h2ulong_callee
    PUBLIC _u32_f16_fastcall

    EXTERN cm16_sdcc___h2ulong_callee
    EXTERN cm16_sdcc___h2ulong_fastcall

    defc ___h2ulong_callee = cm16_sdcc___h2ulong_callee
    defc _u32_f16_fastcall = cm16_sdcc___h2ulong_fastcall
