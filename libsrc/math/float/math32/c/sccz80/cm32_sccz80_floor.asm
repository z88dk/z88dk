

SECTION code_fp_math32
PUBLIC cm32_sccz80_floor

EXTERN cm32_sccz80_fsread1, m32_floor_fastcall

cm32_sccz80_floor:
    call cm32_sccz80_fsread1
    jp m32_floor_fastcall
