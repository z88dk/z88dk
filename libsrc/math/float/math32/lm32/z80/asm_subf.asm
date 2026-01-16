
; float _subf (float left, float right) __z88dk_callee

SECTION code_clib
SECTION code_fp_math32

PUBLIC asm_subf

EXTERN m32_fssub_callee

    ; subtract sccz80 float from sccz80 float
    ;
    ; enter : stack = sccz80_float left, ret
    ;          DEHL = sccz80_float right
    ;
    ; exit  :  DEHL = sccz80_float(left+right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

DEFC  asm_subf = m32_fssub_callee       ; enter stack = d32_float left
                                        ;        DEHL = d32_float right
                                        ; return DEHL = d32_float
