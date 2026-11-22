
SECTION code_fp_math32

PUBLIC cm32_sdcc_frexp_callee

EXTERN m32_fsfrexp_callee

; float frexpf(float x, int8_t *pw2);

    ; Entry:
    ; Stack: ptr right, float left, ret

defc cm32_sdcc_frexp_callee = m32_fsfrexp_callee
