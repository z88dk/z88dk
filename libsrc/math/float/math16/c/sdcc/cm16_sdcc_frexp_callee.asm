
SECTION code_fp_math16

PUBLIC cm16_sdcc_frexp_callee

EXTERN asm_f16_frexp

; half_t frexp(half_t x, int8_t *pw2);

    ; Entry:
    ; Stack: ptr right, half_t left, ret

.cm16_sdcc_frexp_callee
    pop de                      ;my return
    pop hl                      ;half_t
    pop bc                      ;ptr
    push de                     ;my return
    jp  asm_f16_frexp
