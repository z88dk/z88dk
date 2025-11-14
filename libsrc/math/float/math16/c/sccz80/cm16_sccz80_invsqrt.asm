

SECTION code_fp_math16
PUBLIC cm16_sccz80_invsqrt

EXTERN cm16_sccz80_read1, asm_f16_invsqrt

cm16_sccz80_invsqrt:
    call cm16_sccz80_read1
    jp asm_f16_invsqrt
