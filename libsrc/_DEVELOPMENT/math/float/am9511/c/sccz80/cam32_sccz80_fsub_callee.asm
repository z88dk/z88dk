
; float __fsub_callee (float left, float right)

SECTION code_clib
SECTION code_fp_am9511

PUBLIC cam32_sccz80_fsub_callee

EXTERN asm_am9511_fsub_callee

    ; subtract sccz80 float from sccz80 float
    ;
    ; enter : stack = sccz80_float left, ret
    ;          DEHL = sccz80_float right
    ;
    ; exit  :  DEHL = sccz80_float(left-right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

defc cam32_sccz80_fsub_callee = asm_am9511_fsub_callee
                            ; enter stack = sccz80_float left, ret
                            ;        DEHL = sccz80_float right
                            ; return DEHL = sccz80_float
