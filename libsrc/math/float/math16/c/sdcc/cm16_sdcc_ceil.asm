
SECTION code_fp_math16

PUBLIC cm16_sdcc_ceil

EXTERN cm16_sdcc_read1
EXTERN asm_f16_ceil

.cm16_sdcc_ceil
    call cm16_sdcc_read1
    jp asm_f16_ceil
