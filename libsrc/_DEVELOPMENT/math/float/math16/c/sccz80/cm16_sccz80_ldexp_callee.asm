
SECTION code_fp_math16

PUBLIC cm16_sccz80_ldexp_callee

EXTERN asm_f16_ldexp_callee

; half ldexpf(half x, int16_t pw2);

.cm16_sccz80_ldexp_callee
    ; Entry:
    ; Stack: half left, int right, ret

    ; Reverse the stack
    pop af                      ;my return
    pop bc                      ;int
    pop hl                      ;half
    push bc                     ;int
    push hl                     ;half
    push af                     ;my return
    jp asm_f16_ldexp_callee

