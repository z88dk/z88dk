
; half __add_callee (half left, half right)

SECTION code_fp_math16

PUBLIC cm16_sccz80_add_callee

EXTERN asm_f16_add_callee

    ; add two sccz80 halfs
    ;
    ; enter : stack = sccz80_half left, ret
    ;            HL = sccz80_half right
    ;
    ; exit  :    HL = sccz80_half(left+right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

defc cm16_sccz80_add_callee = asm_f16_add_callee
                            ; enter stack = sccz80_half left, ret
                            ;          HL = sccz80_half right
                            ; return   HL = sccz80_half

