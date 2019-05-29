

SECTION code_fp_math32
PUBLIC cm32_sccz80_ceil

EXTERN cm32_sccz80_fsread1, m32_ceil_fastcall

cm32_sccz80_ceil:
    call cm32_sccz80_fsread1
    jp m32_ceil_fastcall
