
SECTION code_fp_math16

PUBLIC cm16_sccz80_ldexp_callee

EXTERN asm_f16_ldexp

; half_t ldexp(half_t x, int16_t pw2);

.cm16_sccz80_ldexp_callee
    ; Entry:
    ; Stack: half_t left, int right, ret

    ; Reverse the stack
    pop de                      ;my return
    pop bc                      ;int
    pop hl                      ;half_t
    push de                     ;my return
    jp asm_f16_ldexp

