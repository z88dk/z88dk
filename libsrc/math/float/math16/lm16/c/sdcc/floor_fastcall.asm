
    SECTION code_fp_math16
    PUBLIC  _floorf16_fastcall
    EXTERN  asm_f16_floor

    defc    _floorf16_fastcall = asm_f16_floor
