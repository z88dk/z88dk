
    SECTION code_fp_math16

    PUBLIC l_f16_ftof16
    PUBLIC l_f16_f16tof

    PUBLIC f16_f16_f32
    PUBLIC f16_f32_f16

    PUBLIC f16_f16_f48
    PUBLIC f16_f48_f16

    PUBLIC f16_f16_f24
    PUBLIC f16_f24_f16

    PUBLIC f16_f24_f32
    PUBLIC f16_f32_f24

    EXTERN l_ret
    
    EXTERN asm_f32_f48
    EXTERN asm_f48_f32
    
    EXTERN asm_f24_f32
    EXTERN asm_f32_f24

    EXTERN asm_f16_f24
    EXTERN asm_f24_f16

defc l_f16_f16tof = l_ret
defc l_f16_ftof16 = l_ret  

.f16_f16_f48
    call asm_f32_f48
.f16_f16_f32
    call asm_f24_f32
    jp asm_f16_f24

.f16_f48_f16
    call asm_f24_f16
    call asm_f32_f24
    jp asm_f48_f32

.f16_f32_f16
    call asm_f24_f16
    jp asm_f32_f24

defc f16_f16_f24 = asm_f16_f24
defc f16_f24_f16 = asm_f24_f16
defc f16_f24_f32 = asm_f24_f32
defc f16_f32_f24 = asm_f32_f24
defc f16_f32_f24 = asm_f32_f48
defc f16_f24_f32 = asm_f48_f32

