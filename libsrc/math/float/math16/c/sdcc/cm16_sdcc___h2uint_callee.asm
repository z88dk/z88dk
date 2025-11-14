
SECTION code_fp_math16

PUBLIC cm16_sdcc___h2uint_callee
PUBLIC cm16_sdcc___h2uchar_callee

PUBLIC cm16_sdcc___h2uint_fastcall
PUBLIC cm16_sdcc___h2uchar_fastcall

EXTERN cm16_sdcc_read1_callee
EXTERN asm_f24_f16
EXTERN asm_u16_f24

.cm16_sdcc___h2uint_callee
.cm16_sdcc___h2uchar_callee
    call cm16_sdcc_read1_callee
.cm16_sdcc___h2uint_fastcall
.cm16_sdcc___h2uchar_fastcall
    call asm_f24_f16
    jp asm_u16_f24

