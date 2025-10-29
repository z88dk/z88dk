
SECTION code_fp_math32

PUBLIC cm32_sdcc_ldexp_callee

EXTERN m32_fsldexp_callee

; float ldexpf(float x, int16_t pw2);

    ; Entry:
    ; Stack: int right, float left, ret

defc cm32_sdcc_ldexp_callee = m32_fsldexp_callee
