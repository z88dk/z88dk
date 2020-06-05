
SECTION code_fp_math16

PUBLIC cm16_sdcc___h2sint_callee
PUBLIC cm16_sdcc___h2schar_callee

EXTERN cm16_sdcc_read1_callee
EXTERN asm_f24_f16
EXTERN asm_i16_f24

.cm16_sdcc___h2sint_callee
.cm16_sdcc___h2schar_callee
    call cm16_sdcc_read1_callee
    call asm_f24_f16
    jp asm_i16_f24

