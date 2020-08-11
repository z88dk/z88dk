
SECTION code_fp_am9511

PUBLIC cam32_sccz80_frexp

EXTERN asm_am9511_frexp_callee

; float frexpf(float x, int16_t *pw2);

.cam32_sccz80_frexp
    ; Entry:
    ; Stack: float left, ptr right, ret
    ; Reverse the stack
    pop af                      ;my return
    pop bc                      ;ptr
    pop hl                      ;float
    pop de
    push af                     ;my return
    push bc                     ;ptr
    push de                     ;float
    push hl
    call asm_am9511_frexp_callee

    pop af                      ;my return
    push af
    push af
    push af
    push af
    ret
