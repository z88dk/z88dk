
; long __lmul_callee (long left, long right)

SECTION code_clib
SECTION code_fp_am9511

PUBLIC cam32_sccz80_lmul_callee

EXTERN asm_am9511_lmul_callee

    ; multiply two sccz80 longs
    ;
    ; enter : stack = sccz80_long left, ret
    ;          DEHL = sccz80_long right
    ;
    ; exit  :  DEHL = sccz80_long(left*right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

defc cam32_sccz80_lmul_callee = asm_am9511_lmul_callee
                            ; enter stack = sccz80_long left, ret
                            ;        DEHL = sccz80_long right
                            ; return DEHL = sccz80_long
