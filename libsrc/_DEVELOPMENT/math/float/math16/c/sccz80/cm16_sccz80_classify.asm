

SECTION code_fp_math16
PUBLIC cm16_sccz80_classify

EXTERN cm16_sccz80_fsread1, asm_f16_classify

cm16_sccz80_classify:
    call cm16_sccz80_fsread1
    call asm_f16_classify
    ld l,a
    ld h,0
    ret

