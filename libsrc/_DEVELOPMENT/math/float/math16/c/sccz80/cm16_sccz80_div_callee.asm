
; half __div_callee (half left, half right)

SECTION code_fp_math16

PUBLIC cm16_sccz80_div_callee

EXTERN asm_f16_div_callee

    ; divide sccz80 half by sccz80 half
    ;
    ; enter : stack = sccz80_half left, ret
    ;            HL = sccz80_half right
    ;
    ; exit  :    HL = sccz80_half(left/right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

defc cm16_sccz80_div_callee = asm_f16_div_callee
                            ; enter stack = sccz80_half left, ret
                            ;          HL = sccz80_half right
                            ; return   HL = sccz80_half

