
SECTION code_fp_math32

PUBLIC cm32_sdcc_frexp

EXTERN m32_fsfrexp

; float frexpf(float x, int8_t *pw2);

    ; Entry:
    ; Stack: ptr right, float left, ret
    
defc cm32_sdcc_frexp = m32_fsfrexp
