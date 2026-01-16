
    SECTION code_fp_math16

    PUBLIC _f16_f32_fastcall
    PUBLIC _f32_f16_fastcall

    PUBLIC _f16_f24_fastcall
    PUBLIC _f24_f16_fastcall

    PUBLIC _f24_f32_fastcall
    PUBLIC _f32_f24_fastcall

    EXTERN asm_f24_f32
    EXTERN asm_f32_f24

    EXTERN asm_f16_f24
    EXTERN asm_f24_f16

._f16_f32_fastcall
    call asm_f24_f32
    jp asm_f16_f24

._f32_f16_fastcall
    call asm_f24_f16
    jp asm_f32_f24

defc _f16_f24_fastcall = asm_f16_f24
defc _f24_f16_fastcall = asm_f24_f16
defc _f24_f32_fastcall = asm_f24_f32
defc _f32_f24_fastcall = asm_f32_f24
