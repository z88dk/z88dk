

SECTION code_fp_math32
PUBLIC cm32_sccz80_fabs

EXTERN cm32_sccz80_fsread1, m32_fabs_fastcall

cm32_sccz80_fabs:
    call cm32_sccz80_fsread1
    jp m32_fabs_fastcall
