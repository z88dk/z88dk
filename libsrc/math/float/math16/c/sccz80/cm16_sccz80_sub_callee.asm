
; half __sub_callee (half left, half right)

SECTION code_fp_math16

PUBLIC cm16_sccz80_sub_callee

EXTERN asm_f24_f16
EXTERN asm_f16_f24

EXTERN asm_f24_add_f24
EXTERN asm_f24_neg

.cm16_sccz80_sub_callee

    ; subtract sccz80 half from sccz80 half
    ;
    ; enter : stack = sccz80_half left, sccz80_half right, ret
    ;
    ; exit  :    HL = sccz80_half(left+right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    pop bc                      ; pop return address
    pop hl                      ; get right operand off of the stack
    exx

    pop hl                      ; get left operand off of the stack
    call asm_f24_f16            ; expand to dehl
    exx                         ; x      d  = eeeeeeee e  = s-------
                                ;        hl = 1mmmmmmm mmmmmmmm
    push bc                     ; return address on stack
    call asm_f24_f16            ; expand to dehl
    call asm_f24_neg
    call asm_f24_add_f24
    jp asm_f16_f24              ; return HL = sccz80_half

