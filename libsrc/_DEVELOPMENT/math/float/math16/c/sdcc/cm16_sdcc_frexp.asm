
SECTION code_fp_math16

PUBLIC cm16_sdcc_frexp

EXTERN asm_f16_frexp_callee

; half frexpf(half x, int16_t *pw2);

.cm16_sdcc_frexp

    ; Entry:
    ; Stack: ptr right, half left, ret
    
    pop af                      ; my return
    pop hl                      ; (half)x
    pop bc                      ; (int*)pw2
    push af                     ; my return   
    push bc                     ; (int*)pw2
    push hl                     ; (half)x
    call asm_f16_frexp_callee

    pop af                      ; my return
    push af
    push af
    push af
    ret

