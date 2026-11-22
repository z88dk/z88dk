
SECTION code_clib
SECTION code_fp_am9511

PUBLIC cam32_sccz80_fmod

EXTERN asm_switch_arg
EXTERN _am9511_fmod


.cam32_sccz80_fmod
    call asm_switch_arg
    jp _am9511_fmod
