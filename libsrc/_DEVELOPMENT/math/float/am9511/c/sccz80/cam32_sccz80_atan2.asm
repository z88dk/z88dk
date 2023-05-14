
SECTION code_fp_am9511

PUBLIC cam32_sccz80_atan2

EXTERN asm_switch_arg
EXTERN _am9511_atan2

.cam32_sccz80_atan2
    call asm_switch_arg
    jp _am9511_atan2
