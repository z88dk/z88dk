SECTION code_clib
SECTION code_fp_math16
PUBLIC cm16_sccz80_sqr

EXTERN cm16_sccz80_read1, asm_f16_sqr

cm16_sccz80_sqr:
    call cm16_sccz80_read1
    jp asm_f16_sqr
