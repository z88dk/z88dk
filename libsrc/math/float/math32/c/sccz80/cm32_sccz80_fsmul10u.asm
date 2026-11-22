

SECTION code_fp_math32
PUBLIC cm32_sccz80_fsmul10u

EXTERN cm32_sccz80_fsread1, m32_fsmul10u_fastcall

cm32_sccz80_fsmul10u:
    call cm32_sccz80_fsread1
    jp m32_fsmul10u_fastcall
