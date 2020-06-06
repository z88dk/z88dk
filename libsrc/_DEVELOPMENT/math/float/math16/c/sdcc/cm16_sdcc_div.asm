
; half __div (half left, half right)

SECTION code_fp_math16

PUBLIC cm16_sdcc_div

EXTERN asm_f24_f16
EXTERN asm_f16_f24

EXTERN asm_f24_mul_f24
EXTERN asm_f24_inv

EXTERN cm16_sdcc_readr

.cm16_sdcc_div

    ; divide sdcc half by sdcc half
    ;
    ; enter : stack = sdcc_half right, sdcc_half left, ret
    ;
    ; exit  : DEHL = sdcc_half(left/right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call cm16_sdcc_readr

    call asm_f24_f16            ; expand to dehl
    call asm_f24_inv            ; 1/y   d'  = eeeeeeee e' = s-------
    exx                         ;       hl' = 1mmmmmmm mmmmmmmm
    
    pop bc                      ; pop return address
    pop hl                      ; get left operand off of the stack
    push hl                     ; left operand on stack
    push bc                     ; return address on stack
    call asm_f24_f16            ; expand to dehl
                                ; x      d  = eeeeeeee e  = s-------
                                ;        hl = 1mmmmmmm mmmmmmmm
    call asm_f24_mul_f24
    jp asm_f16_f24              ; return   HL = sdcc_half

