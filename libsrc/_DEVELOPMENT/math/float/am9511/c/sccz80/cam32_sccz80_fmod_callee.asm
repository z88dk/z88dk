
SECTION code_fp_am9511

PUBLIC cam32_sccz80_fmod_callee

EXTERN _am9511_fmod, asm_switch_arg

.cam32_sccz80_fmod_callee
    ; Entry:
    ; Stack: float left, float right, ret
    ; Reverse the stack (not for Intel)
IF !__CPU_INTEL__
    call asm_switch_arg
ENDIF
    call _am9511_fmod
    pop bc
    pop af
    pop af
    pop af
    pop af
    push bc
    ret
