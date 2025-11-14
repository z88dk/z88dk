

SECTION code_fp_math32
PUBLIC cm32_sccz80_fsdiv2

EXTERN cm32_sccz80_fsread1, m32_fsdiv2_fastcall

cm32_sccz80_fsdiv2:
    call cm32_sccz80_fsread1
    jp m32_fsdiv2_fastcall
