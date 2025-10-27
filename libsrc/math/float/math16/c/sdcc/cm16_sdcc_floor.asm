
SECTION code_fp_math16

PUBLIC cm16_sdcc_floor

EXTERN cm16_sdcc_read1
EXTERN asm_f16_floor

.cm16_sdcc_floor
    call cm16_sdcc_read1
    jp asm_f16_floor

