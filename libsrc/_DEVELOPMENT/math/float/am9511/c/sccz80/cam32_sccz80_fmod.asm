
SECTION code_fp_am9511

PUBLIC cam32_sccz80_fmod

EXTERN cam32_sccz80_switch_arg
EXTERN _am9511_fmodf

.cam32_sccz80_fmod
    call cam32_sccz80_switch_arg
    jp _am9511_fmodf
