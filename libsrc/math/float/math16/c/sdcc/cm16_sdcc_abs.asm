
SECTION code_fp_math16

PUBLIC cm16_sdcc_fabs

EXTERN cm16_sdcc_read1
EXTERN asm_f16_fabs

.cm16_sdcc_fabs
    call cm16_sdcc_read1
    jp asm_f16_fabs
