

SECTION code_fp_am9511

PUBLIC cam32_sccz80_hypot_callee

EXTERN asm_am9511_hypot_callee

    ; find the hypotenuse of two sccz80 floats
    ;
    ; enter : stack = sccz80_float left, sccz80_float right, ret
    ;
    ; exit  :  DEHL = sccz80_float(left+right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

.cam32_sccz80_hypot_callee
    pop bc                      ; ret
    pop hl                      ; sccz80_float
    pop de
    push bc                     ; ret

    jp asm_am9511_hypot_callee  ; enter stack = sccz80_float left, ret
                                ;        DEHL = sccz80_float right
                                ; return DEHL = sccz80_float
