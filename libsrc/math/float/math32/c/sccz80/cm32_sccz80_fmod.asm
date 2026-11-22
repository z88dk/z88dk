
SECTION code_fp_math32

PUBLIC cm32_sccz80_fmod

EXTERN cm32_sccz80_switch_arg
EXTERN _m32_fmodf

.cm32_sccz80_fmod
    call cm32_sccz80_switch_arg
    jp _m32_fmodf
