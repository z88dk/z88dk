
    SECTION code_fp_math16

    PUBLIC  l_f16_uchar2f
    PUBLIC  l_f16_schar2f
    PUBLIC  l_f16_uint2f
    PUBLIC  l_f16_sint2f
    PUBLIC  l_f16_ulong2f
    PUBLIC  l_f16_slong2f

    EXTERN asm_f16_f24
    
    EXTERN asm_f24_u8
    EXTERN asm_f24_i8
    EXTERN asm_f24_u16
    EXTERN asm_f24_i16
    EXTERN asm_f24_u32
    EXTERN asm_f24_i32

.l_f16_uchar2f
    call asm_f24_u8
    jp asm_f16_f24

.l_f16_schar2f
    call asm_f24_i8
    jp asm_f16_f24
    
.l_f16_uint2f
    call asm_f24_u16
    jp asm_f16_f24
    
.l_f16_sint2f
    call asm_f24_i16
    jp asm_f16_f24

.l_f16_ulong2f
    call asm_f24_u32
    jp asm_f16_f24

.l_f16_slong2f
    call asm_f24_i32
    jp asm_f16_f24

