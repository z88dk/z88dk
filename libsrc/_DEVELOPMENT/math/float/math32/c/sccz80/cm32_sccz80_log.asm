

SECTION code_fp_math32
PUBLIC cm32_sccz80_log

EXTERN cm32_sccz80_fsread1, _m32_logf

cm32_sccz80_log:
    call cm32_sccz80_fsread1
    jp _m32_logf
