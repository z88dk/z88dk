
SECTION code_fp_am9511

PUBLIC cam32_sdcc_ldexp_callee

EXTERN asm_am9511_ldexp_callee

; float ldexpf(float x, int16_t pw2);

    ; Entry:
    ; Stack: int right, float left, ret

defc cam32_sdcc_ldexp_callee = asm_am9511_ldexp_callee
