
    SECTION code_clib
    SECTION code_fp_math48

    PUBLIC l_f48_ftof16
    PUBLIC l_f48_f16tof

    EXTERN asm_f32_f48
    EXTERN asm_f48_f32

    EXTERN asm_f24_f32
    EXTERN asm_f32_f24

    EXTERN asm_f16_f24
    EXTERN asm_f24_f16

.l_f48_ftof16
    call asm_f32_f48
    call asm_f24_f32
    jp asm_f16_f24

.l_f48_f16tof
    call asm_f24_f16
    call asm_f32_f24
    jp asm_f48_f32

