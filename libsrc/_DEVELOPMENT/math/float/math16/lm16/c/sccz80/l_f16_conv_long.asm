
    SECTION code_fp_math16

    PUBLIC  l_f16_ulong2f
    PUBLIC  l_f16_slong2f

	PUBLIC	l_f16_f2slong
	PUBLIC	l_f16_f2ulong

    PUBLIC m16_i32_f16
    PUBLIC m16_u32_f16

    PUBLIC m16_f16_i32
    PUBLIC m16_f16_u32

    EXTERN asm_f16_f24
    EXTERN asm_f24_f16

    EXTERN asm_f24_u32
    EXTERN asm_f24_i32

    EXTERN asm_i32_f24
    EXTERN asm_u32_f24

.l_f16_ulong2f
.m16_f16_u32
    call asm_f24_u32
    jp asm_f16_f24

.l_f16_slong2f
.m16_f16_i32
    call asm_f24_i32
    jp asm_f16_f24

.l_f16_f2slong
.m16_i32_f16
    call asm_f24_f16
    jp asm_i32_f24

.l_f16_f2ulong
.m16_u32_f16
    call asm_f24_f16
    jp asm_u32_f24

