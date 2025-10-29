
    SECTION code_fp_math16

    PUBLIC ___h2slong_callee
    PUBLIC _i32_f16_fastcall

    EXTERN cm16_sdcc___h2slong_callee
    EXTERN cm16_sdcc___h2slong_fastcall

    defc ___h2slong_callee = cm16_sdcc___h2slong_callee
    defc _i32_f16_fastcall = cm16_sdcc___h2slong_fastcall
