
    SECTION code_fp_math16

    PUBLIC  l_f16_ulong2f
    PUBLIC  l_f16_slong2f

	PUBLIC	l_f16_f2slong
	PUBLIC	l_f16_f2ulong

    EXTERN asm_f16_f24
    EXTERN asm_f24_f16

    EXTERN asm_f24_u32
    EXTERN asm_f24_i32

    EXTERN asm_i32_f24
    EXTERN asm_u32_f24

.l_f16_ulong2f
    call asm_f24_u32
    jp asm_f16_f24

.l_f16_slong2f
    call asm_f24_i32
    jp asm_f16_f24

.l_f16_f2slong
    call asm_f24_f16
    jp asm_i32_f24

.l_f16_f2ulong
    call asm_f24_f16
    jp asm_u32_f24

