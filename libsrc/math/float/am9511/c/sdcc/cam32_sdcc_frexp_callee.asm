
SECTION code_fp_am9511

PUBLIC cam32_sdcc_frexp_callee

EXTERN asm_am9511_frexp_callee

; float frexpf(float x, int8_t *pw2);

    ; Entry:
    ; Stack: ptr right, float left, ret

defc cam32_sdcc_frexp_callee = asm_am9511_frexp_callee
