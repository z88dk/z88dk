
    SECTION code_fp_math32

    PUBLIC l_f32_ftof16
    PUBLIC l_f32_f16tof

    EXTERN asm_f24_f32
    EXTERN asm_f32_f24

    EXTERN asm_f16_f24
    EXTERN asm_f24_f16

.l_f32_ftof16
    call asm_f24_f32
    jp asm_f16_f24

.l_f32_f16tof
    call asm_f24_f16
    jp asm_f32_f24

