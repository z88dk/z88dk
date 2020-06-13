
    SECTION code_fp_math16
    PUBLIC  _f16_floor_fastcall
    EXTERN  asm_f16_floor

    defc    _f16_floor_fastcall = asm_f16_floor
