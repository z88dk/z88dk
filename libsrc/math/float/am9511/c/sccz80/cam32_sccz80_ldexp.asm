
SECTION code_fp_am9511

PUBLIC cam32_sccz80_ldexp

EXTERN asm_am9511_ldexp_callee

; float ldexpf(float x, int16_t pw2);

.cam32_sccz80_ldexp
    ; Entry:
    ; Stack: float left, int right, ret
    ; Reverse the stack, return on top

    pop hl                      ;my return
    pop bc                      ;int
    pop de                      ;float LSW
    ex (sp),hl                  ;float MSW <-> my return
    push bc                     ;int
    push hl                     ;float MSW
    push de                     ;float LSW
    call asm_am9511_ldexp_callee

    pop bc                      ;my return
    push af
    push af
    push af
    push bc
    ret
