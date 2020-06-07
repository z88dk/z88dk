
SECTION code_fp_math16

PUBLIC cm16_sdcc_div2

EXTERN cm16_sdcc_read1
EXTERN asm_f16_div2

.cm16_sdcc_div2
    call cm16_sdcc_read1
    jp asm_f16_div2

