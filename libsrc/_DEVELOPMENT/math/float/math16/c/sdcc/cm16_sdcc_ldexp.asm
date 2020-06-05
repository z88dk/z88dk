
SECTION code_fp_math16

PUBLIC cm16_sdcc_ldexp

EXTERN asm_f16_ldexp_callee

; half ldexpf(half x, int16_t pw2);

.cm16_sdcc_ldexp

    ; Entry:
    ; Stack: int right, half left, ret

    pop af                      ; my return
    pop hl                      ; (half)x
    pop bc                      ; pw2
    push af                     ; my return   
    push bc                     ; pw2
    push hl                     ; (half)x
    call asm_f16_ldexp_callee

    pop af                      ; my return
    push af
    push af
    push af
    ret
    
