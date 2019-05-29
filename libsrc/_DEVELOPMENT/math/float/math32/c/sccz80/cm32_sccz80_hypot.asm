
SECTION code_fp_math32

PUBLIC cm32_sccz80_hypot

EXTERN cm32_sccz80_switch_arg
EXTERN _m32_hypotf

cm32_sccz80_hypot:
    call cm32_sccz80_switch_arg
    jp _m32_hypotf
