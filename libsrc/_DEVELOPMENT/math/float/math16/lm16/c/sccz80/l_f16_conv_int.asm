
    SECTION code_fp_math16

    PUBLIC  l_f16_uchar2f
    PUBLIC  l_f16_schar2f
    PUBLIC  l_f16_uint2f
    PUBLIC  l_f16_sint2f

	PUBLIC	l_f16_f2sint
	PUBLIC	l_f16_f2uint

    PUBLIC i16_f16
    PUBLIC u16_f16

    PUBLIC f16_i8
    PUBLIC f16_u8
    PUBLIC f16_i16
    PUBLIC f16_u16

    EXTERN asm_f16_f24
    EXTERN asm_f24_f16

    EXTERN asm_f24_u8
    EXTERN asm_f24_i8
    EXTERN asm_f24_u16
    EXTERN asm_f24_i16

    EXTERN asm_i16_f24
    EXTERN asm_u16_f24

.l_f16_uchar2f
.f16_u8
    call asm_f24_u8
    jp asm_f16_f24

.l_f16_schar2f
.f16_i8
    call asm_f24_i8
    jp asm_f16_f24
    
.l_f16_uint2f
.f16_u16
    call asm_f24_u16
    jp asm_f16_f24
    
.l_f16_sint2f
.f16_i16
    call asm_f24_i16
    jp asm_f16_f24

.l_f16_f2sint
.i16_f16
    call asm_f24_f16
    jp asm_i16_f24

.l_f16_f2uint
.u16_f16
    call asm_f24_f16
    jp asm_u16_f24

