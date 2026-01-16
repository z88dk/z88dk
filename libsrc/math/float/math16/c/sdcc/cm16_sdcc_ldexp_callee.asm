
SECTION code_fp_math16

PUBLIC cm16_sdcc_ldexp_callee

EXTERN asm_f16_ldexp

; half_t ldexp(half_t x, int16_t pw2);

.cm16_sdcc_ldexp_callee
    ; Entry:
    ; Stack: int right, half_t left, ret

    pop de                      ; my return
    pop hl                      ; half_t
    pop bc                      ; int
    push de                     ; my return
    jp asm_f16_ldexp

