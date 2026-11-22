
SECTION code_fp_math32

PUBLIC cm32_sccz80_atan2

EXTERN cm32_sccz80_switch_arg
EXTERN _m32_atan2f

cm32_sccz80_atan2:
    call cm32_sccz80_switch_arg
    jp _m32_atan2f
