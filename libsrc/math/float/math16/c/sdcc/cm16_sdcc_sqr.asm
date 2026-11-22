; half __sqr (half number)

SECTION code_clib
SECTION code_fp_math16

PUBLIC cm16_sdcc_sqr

EXTERN cm16_sdcc_read1
EXTERN asm_f16_sqr

.cm16_sdcc_sqr
    call cm16_sdcc_read1
    jp asm_f16_sqr
