
SECTION code_fp_math16

PUBLIC cm16_sdcc_mul10

EXTERN cm16_sdcc_read1
EXTERN asm_f16_mul10

.cm16_sdcc_mul10
    call cm16_sdcc_read1
    jp asm_f16_mul10
