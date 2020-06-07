
    SECTION code_fp_math16

    PUBLIC m16_f16_f32
    PUBLIC m16_f32_f16

    PUBLIC m16_f16_f24
    PUBLIC m16_f24_f16

    PUBLIC m16_f24_f32
    PUBLIC m16_f32_f24

    EXTERN asm_f24_f32
    EXTERN asm_f32_f24

    EXTERN asm_f16_f24
    EXTERN asm_f24_f16
    
.m16_f16_f32
    call asm_f24_f32
    jp asm_f16_f24

.m16_f32_f16
    call asm_f24_f16
    jp asm_f32_f24

defc m16_f16_f24 = asm_f16_f24
defc m16_f24_f16 = asm_f24_f16
defc m16_f24_f32 = asm_f24_f32
defc m16_f32_f24 = asm_f32_f24
