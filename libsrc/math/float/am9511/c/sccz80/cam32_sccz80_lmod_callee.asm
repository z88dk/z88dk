
; long __lmod_callee (long left, long right)

SECTION code_clib
SECTION code_fp_am9511

PUBLIC cam32_sccz80_lmod_callee

EXTERN asm_am9511_lmod_callee

    ; modulus of sccz80 long by sccz80 long
    ;
    ; enter : stack = sccz80_long left, ret
    ;          DEHL = sccz80_long right
    ;
    ; exit  :  DEHL = sccz80_long(left/right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

defc cam32_sccz80_lmod_callee = asm_am9511_lmod_callee
                            ; enter stack = sccz80_long left, ret
                            ;        DEHL = sccz80_long right
                            ; return DEHL = sccz80_long
