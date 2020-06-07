
; half_t __fma_callee (half_t left, half_t middle, half_t right)

SECTION code_fp_math16

PUBLIC cm16_sdcc_fma_callee

EXTERN asm_f24_f16
EXTERN asm_f16_f24

EXTERN asm_f24_mul_f24
EXTERN asm_f24_add_f24

.cm16_sdcc_fma_callee

    ; fma three sdcc halfs
    ;
    ; enter : stack = sdcc_half right, sdcc_half middle, sdcc_half left, ret
    ;
    ; exit  :   HL = sdcc_half(left*middle+right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'


    pop bc                      ; pop return address
    pop hl                      ; get left operand off of the stack
    call asm_f24_f16            ; expand left to dehl
    exx

    pop hl                      ; get middle operand off of the stack
    call asm_f24_f16            ; expand middle to dehl
    exx

    push bc                     ; return address on stack
    call asm_f24_mul_f24
    exx

    pop bc                      ; pop return address
    pop hl                      ; get right operand off the stack
    push bc                     ; return address on stack
    call asm_f24_f16            ; expand right to dehl
    call asm_f24_add_f24
    jp asm_f16_f24              ; return HL = sdcc_half

