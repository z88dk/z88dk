
SECTION code_fp_math16

PUBLIC cm16_sdcc_ldexp_callee

EXTERN asm_f16_ldexp_callee

; half_t ldexpf(half_t x, int16_t pw2);

    ; Entry:
    ; Stack: int right, half_t left, ret

.cm16_sdcc_ldexp_callee
    pop de                      ; my return
    pop hl                      ; half_t
    pop bc                      ; int
    push de                     ; my return   
    jp asm_f16_ldexp_callee

