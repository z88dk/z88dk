
SECTION code_clib
SECTION code_fp_am9511

PUBLIC cam32_sccz80_frexp_callee

EXTERN asm_am9511_frexp_callee

; float frexpf(float x, int16_t *pw2);

.cam32_sccz80_frexp_callee
    ; Entry:
    ; Stack: float left, ptr right, ret
    ; Reverse the stack, return on top

    pop hl                      ;my return
    pop bc                      ;ptr
    pop de                      ;float LSW
    ex (sp),hl                  ;float MSW <-> my return
    push bc                     ;ptr
    push hl                     ;float MSW
    push de                     ;float LSW
    call asm_am9511_frexp_callee
    ret

