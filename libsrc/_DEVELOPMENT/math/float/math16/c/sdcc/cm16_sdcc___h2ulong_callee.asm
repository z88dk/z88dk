
SECTION code_fp_math16

PUBLIC cm16_sdcc___h2ulong_callee
PUBLIC cm16_sdcc___h2ulong_fastcall

EXTERN cm16_sdcc_read1_callee
EXTERN asm_f24_f16
EXTERN asm_u32_f24

.cm16_sdcc___h2ulong_callee
    call cm16_sdcc_read1_callee
.cm16_sdcc___h2ulong_fastcall
    call asm_f24_f16
    jp asm_u32_f24

