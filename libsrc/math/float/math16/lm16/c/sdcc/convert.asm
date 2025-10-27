
    SECTION code_fp_math16

    PUBLIC _f16_f32
    PUBLIC _f32_f16

    PUBLIC _f16_f24
    PUBLIC _f24_f16

    PUBLIC _f24_f32
    PUBLIC _f32_f24

    EXTERN asm_f24_f32
    EXTERN asm_f32_f24

    EXTERN asm_f16_f24
    EXTERN asm_f24_f16
    
    EXTERN cm16_sdcc_read1
    EXTERN cm32_sdcc_read1

._f16_f32
    call cm32_sdcc_read1
    call asm_f24_f32
    jp asm_f16_f24

._f32_f16
    call cm16_sdcc_read1
    call asm_f24_f16
    jp asm_f32_f24

._f16_f24
    call cm32_sdcc_read1
    jp asm_f16_f24

._f24_f16
    call cm16_sdcc_read1
    jp asm_f24_f16

._f24_f32
    call cm32_sdcc_read1
    jp asm_f24_f32

._f32_f24
    call cm32_sdcc_read1
    jp asm_f32_f24

