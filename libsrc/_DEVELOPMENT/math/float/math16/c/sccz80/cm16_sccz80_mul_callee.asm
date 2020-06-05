
; half __mul_callee (half left, half right)

SECTION code_fp_math16

PUBLIC cm16_sccz80_mul_callee

EXTERN asm_f16_mul_callee

    ; multiply two sccz80 hal
    ;
    ; enter : stack = sccz80_half left, ret
    ;            HL = sccz80_half right
    ;
    ; exit  :    HL = sccz80_half(left*right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

defc cm16_sccz80_mul_callee = asm_f16_mul_callee
                            ; enter stack = sccz80_half left, ret
                            ;          HL = sccz80_half right
                            ; return   HL = sccz80_half
