
; half __mul (half left, half right)

SECTION code_fp_math16

PUBLIC cm16_sdcc_mul

EXTERN asm_f24_f16
EXTERN asm_f16_f24

EXTERN asm_f24_mul_f24

.cm16_sdcc_mul

    ; multiply two sdcc halfs
    ;
    ; enter : stack = sdcc_half right, sdcc_half left, ret
    ;
    ; exit  : DEHL = sdcc_half(left*right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    pop bc                      ; pop return address
    pop hl                      ; get left operand off of the stack
    exx

    pop hl                      ; get right operand off of the stack
    push hl
    call asm_f24_f16            ; expand to dehl 
    exx                         ; y     d'  = eeeeeeee e' = s-------
                                ;       hl' = 1mmmmmmm mmmmmmmm
    push hl
    push bc                     ; return address on stack
    call asm_f24_f16            ; expand to dehl
    call asm_f24_mul_f24
    jp asm_f16_f24              ; return HL = sdcc_half

