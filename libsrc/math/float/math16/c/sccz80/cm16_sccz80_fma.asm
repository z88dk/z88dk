
; half_t __fma (half_t left, half_t middle, half_t right)

SECTION code_fp_math16

PUBLIC cm16_sccz80_fma

EXTERN asm_f24_f16
EXTERN asm_f16_f24

EXTERN asm_f24_mul_f24
EXTERN asm_f24_add_f24

.cm16_sccz80_fma

    ; fma three sccz80 halfs
    ;
    ; enter : stack = sccz80_half left, sccz80_half middle, sccz80_half right, ret
    ;
    ; exit  :    HL = sccz80_half(left*middle+right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    pop bc                      ; pop return address
    pop de                      ; get right operand off of the stack
    pop hl                      ; get middle operand off the stack
    exx

    pop hl                      ; get left operand off of the stack
    push hl
    call asm_f24_f16            ; expand left to dehl
    exx

    push hl
    push de
    push bc                     ; return address on stack
    push de                     ; save right operand to add later
    call asm_f24_f16            ; expand middle to dehl
    call asm_f24_mul_f24
    exx

    pop hl                      ; get right operand off the stack
    call asm_f24_f16            ; expand right to dehl
    call asm_f24_add_f24
    jp asm_f16_f24              ; return HL = sccz80_half

