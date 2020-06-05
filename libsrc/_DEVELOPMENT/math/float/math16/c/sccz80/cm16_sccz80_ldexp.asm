
SECTION code_fp_math16

PUBLIC cm16_sccz80_ldexp

EXTERN asm_f16_ldexp_callee

; half ldexpf(half x, int16_t pw2);

.cm16_sccz80_ldexp

    ; Entry:
    ; Stack: half left, int right, ret
    ; Reverse the stack
    pop af                      ;my return
    pop bc                      ;int
    pop hl                      ;half
    push af                     ;my return
    push bc                     ;int
    push hl                     ;half
    call asm_f16_ldexp_callee

    pop af                      ;my return
    push af
    push af
    push af
    ret

