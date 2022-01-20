
SECTION code_fp_am9511

PUBLIC cam32_sccz80_fmod_callee

EXTERN _am9511_fmod, asm_switch_arg

.cam32_sccz80_fmod_callee
    ; Entry:
    ; Stack: float left, float right, ret
    ; Reverse the stack
    call asm_switch_arg
    call _am9511_fmod
    pop af
    pop af
    pop af
    pop af
    ret
