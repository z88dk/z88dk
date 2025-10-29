
SECTION code_fp_math16

PUBLIC cm16_sdcc_neg

EXTERN cm16_sdcc_read1
EXTERN asm_f16_neg

.cm16_sdcc_neg
    call cm16_sdcc_read1
    jp asm_f16_neg
