
SECTION code_fp_math16

PUBLIC cm16_sccz80_frexp_callee

EXTERN asm_f16_frexp_callee

; half frexpf(half x, int16_t *pw2);
.cm16_sccz80_frexp_callee
    ; Entry:
    ; Stack: half left, ptr right, ret

    ; Reverse the stack
    pop af                      ;my return
    pop bc                      ;ptr
    pop hl                      ;half
    push bc                     ;ptr
    push hl                     ;half
    push af                     ;my return
    jp  asm_f16_frexp_callee
