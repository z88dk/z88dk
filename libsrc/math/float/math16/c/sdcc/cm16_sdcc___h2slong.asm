
SECTION code_fp_math16

PUBLIC cm16_sdcc___h2slong

EXTERN cm16_sdcc_read1
EXTERN asm_f24_f16
EXTERN asm_i32_f24

.cm16_sdcc___h2slong
    call cm16_sdcc_read1
    call asm_f24_f16
    jp asm_i32_f24

