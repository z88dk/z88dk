
SECTION code_clib
SECTION code_fp_am9511

PUBLIC cam32_sccz80_atan2_callee

EXTERN _am9511_atan2f, asm_switch_arg


.cam32_sccz80_atan2_callee
    call asm_switch_arg
    call _am9511_atan2f
    pop af
    pop af
    pop af
    pop af
    ret
