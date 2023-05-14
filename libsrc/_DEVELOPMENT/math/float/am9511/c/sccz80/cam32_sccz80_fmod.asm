
SECTION code_clib
SECTION code_fp_am9511

PUBLIC cam32_sccz80_fmod

EXTERN asm_switch_arg
EXTERN _am9511_fmod


.cam32_sccz80_fmod
IF !__CPU_INTEL__
    call asm_switch_arg
ENDIF
    jp _am9511_fmod
