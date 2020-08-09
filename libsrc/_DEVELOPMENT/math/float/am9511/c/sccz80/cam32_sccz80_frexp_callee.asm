
SECTION code_fp_am9511

PUBLIC cam32_sccz80_frexp_callee

EXTERN asm_am9511_frexp_callee

; float frexpf(float x, int16_t *pw2);

.cam32_sccz80_frexp_callee
    ; Entry:
    ; Stack: float left, ptr right, ret
    ; Reverse the stack
    pop af                      ;my return
    pop bc                      ;ptr
    pop hl                      ;float
    pop de
    push bc                     ;ptr
    push de                     ;float
    push hl
    push af                     ;my return
    jp asm_am9511_frexp_callee
