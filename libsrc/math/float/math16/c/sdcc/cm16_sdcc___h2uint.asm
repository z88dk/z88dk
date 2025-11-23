
SECTION code_fp_math16

PUBLIC cm16_sdcc___h2uint
PUBLIC cm16_sdcc___h2uchar

EXTERN cm16_sdcc_read1
EXTERN asm_f24_f16
EXTERN asm_u16_f24

.cm16_sdcc___h2uint
.cm16_sdcc___h2uchar
    call cm16_sdcc_read1
    call asm_f24_f16
    jp asm_u16_f24

