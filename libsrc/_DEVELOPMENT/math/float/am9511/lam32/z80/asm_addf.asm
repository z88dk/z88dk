
; float _addf (float left, float right) __z88dk_callee

SECTION code_clib
SECTION code_fp_am9511

PUBLIC asm_addf

EXTERN asm_am9511_add_callee

    ; add two sccz80 floats
    ;
    ; enter : stack = sccz80_float left, ret
    ;          DEHL = sccz80_float right
    ;
    ; exit  :  DEHL = sccz80_float(left+right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

DEFC  asm_addf = asm_am9511_add_callee  ; enter stack = am9511_float left
                                        ;        DEHL = am9511_float right
                                        ; return DEHL = am9511_float
