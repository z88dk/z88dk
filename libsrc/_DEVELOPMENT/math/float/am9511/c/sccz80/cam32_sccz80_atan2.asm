
SECTION code_fp_am9511

PUBLIC cam32_sccz80_atan2

EXTERN asm_switch_arg
EXTERN _am9511_atan2

.cam32_sccz80_atan2
IF !__CPU_INTEL__
    call asm_switch_arg
ENDIF
    jp _am9511_atan2
