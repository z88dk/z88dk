

SECTION code_fp_math32
PUBLIC cm32_sccz80_sinh

EXTERN cm32_sccz80_fsread1, _m32_sinhf

cm32_sccz80_sinh:
    call cm32_sccz80_fsread1
    jp _m32_sinhf
