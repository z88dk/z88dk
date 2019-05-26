
SECTION code_fp_math32

PUBLIC cm32_sccz80_ldexp

EXTERN m32_fsldexp

; float ldexpf(float x, int16_t pw2);

    ; Entry:
    ; Stack: int right, float left, ret

defc cm32_sccz80_ldexp = m32_fsldexp    
