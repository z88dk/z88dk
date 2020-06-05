
SECTION code_fp_math16

PUBLIC cm16_sdcc_abs

EXTERN cm16_sdcc_read1, asm_f16_abs

.cm16_sdcc_abs
    call cm16_sdcc_read1
    jp asm_f16_abs
