
SECTION code_fp_math16

PUBLIC cm16_sdcc_frexp_callee

EXTERN asm_f16_frexp_callee

; half frexpf(half x, int8_t *pw2);

    ; Entry:
    ; Stack: ptr right, half left, ret

defc cm16_sdcc_frexp_callee = asm_f16_frexp_callee

