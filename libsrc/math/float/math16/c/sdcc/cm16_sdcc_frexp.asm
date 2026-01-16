
SECTION code_fp_math16

PUBLIC cm16_sdcc_frexp

EXTERN asm_f16_frexp

; half_t frexp(half_t x, int16_t *pw2);

.cm16_sdcc_frexp

    ; Entry:
    ; Stack: ptr right, half_t left, ret

    pop de                      ; my return
    pop hl                      ; (half_t)x
    pop bc                      ; (int*)pw2
    
    push bc                     ; (int*)pw2
    push hl                     ; (half_t)x
    push de                     ; my return
    jp asm_f16_frexp

