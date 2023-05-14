
SECTION code_clib
SECTION code_fp_am9511

PUBLIC cam32_sccz80_modf_callee

EXTERN _am9511_modf, asm_switch_arg

; float modff(float x, float * y)
.cam32_sccz80_modf_callee
    ; Entry:
    ; Stack: float left, ptr right, ret

    ; Reverse the stack
IF !__CPU_INTEL__
    call asm_switch_arg
ENDIF
    call _am9511_modf
    pop af
    pop af
    pop af
    ret
