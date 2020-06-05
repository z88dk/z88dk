
; half __sub_callee (half left, half right)

SECTION code_fp_math16

PUBLIC cm16_sccz80_sub_callee

EXTERN asm_f16_sub_callee

    ; subtract sccz80 half from sccz80 half
    ;
    ; enter : stack = sccz80_half left, ret
    ;            HL = sccz80_half right
    ;
    ; exit  :    HL = sccz80_half(left-right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

defc cm16_sccz80_sub_callee = asm_f16_sub_callee
                            ; enter stack = sccz80_half left, ret
                            ;          HL = sccz80_half right
                            ; return   HL = sccz80_half

