
SECTION code_fp_math16

PUBLIC cm16_sdcc___h2slong_callee

EXTERN cm16_sdcc_read1_callee
EXTERN asm_f24_f16
EXTERN asm_i32_f24

.cm16_sdcc___h2slong_callee
    call cm16_sdcc_read1_callee
    call asm_f24_f16
    jp asm_i32_f24

