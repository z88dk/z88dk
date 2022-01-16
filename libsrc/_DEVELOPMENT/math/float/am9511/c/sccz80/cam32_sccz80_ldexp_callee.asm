
SECTION code_clib
SECTION code_fp_am9511

PUBLIC cam32_sccz80_ldexp_callee

EXTERN asm_am9511_ldexp_callee, asm_switch_arg

; float ldexpf(float x, int16_t pw2);

.cam32_sccz80_ldexp_callee
    ; Entry:
    ; Stack: float left, int right, ret
    ; Reverse the stack
    call asm_switch_arg
    jp asm_am9511_ldexp_callee
    
