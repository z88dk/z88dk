

SECTION code_fp_math32
PUBLIC cm32_sccz80_pow

EXTERN cm32_sccz80_switch_arg
EXTERN _m32_powf

cm32_sccz80_pow:
    call cm32_sccz80_switch_arg
    jp _m32_powf
