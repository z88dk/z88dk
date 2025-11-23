

SECTION code_fp_math16
PUBLIC cm16_sdcc_classify

EXTERN cm16_sdcc_read1, asm_f16_classify

.cm16_sdcc_classify
    call cm16_sdcc_read1
    call asm_f16_classify
    ld l,a
    ld h,0
    ret

