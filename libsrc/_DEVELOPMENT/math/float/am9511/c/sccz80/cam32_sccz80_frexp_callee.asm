
SECTION code_clib
SECTION code_fp_am9511

PUBLIC cam32_sccz80_frexp_callee

EXTERN asm_am9511_frexp_callee, asm_switch_arg

; float frexpf(float x, int16_t *pw2);

.cam32_sccz80_frexp_callee
    ; Entry:
    ; Stack: float left, ptr right, ret
    ; Reverse the stack
    call asm_switch_arg
    jp asm_am9511_frexp_callee
