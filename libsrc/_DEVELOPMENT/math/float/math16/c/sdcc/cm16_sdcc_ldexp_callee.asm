
SECTION code_fp_math16

PUBLIC cm16_sdcc_ldexp_callee

EXTERN asm_f16_ldexp_callee

; half ldexpf(half x, int16_t pw2);

    ; Entry:
    ; Stack: int right, half left, ret

defc cm16_sdcc_ldexp_callee = asm_f16_ldexp_callee
