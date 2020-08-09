
SECTION code_fp_am9511

PUBLIC cam32_sccz80_ldexp_callee

EXTERN asm_am9511_ldexp_callee

; float ldexpf(float x, int16_t pw2);

.cam32_sccz80_ldexp_callee
    ; Entry:
    ; Stack: float left, int right, ret
    ; Reverse the stack
    pop af                      ;my return
    pop bc                      ;int
    pop hl                      ;float
    pop de
    push bc                     ;int
    push de                     ;float
    push hl
    push af                     ;my return
    jp asm_am9511_ldexp_callee
    
