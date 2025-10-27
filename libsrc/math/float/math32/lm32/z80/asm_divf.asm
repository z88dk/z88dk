
; float _divf (float left, float right) __z88dk_callee

SECTION code_clib
SECTION code_fp_math32

PUBLIC asm_divf

EXTERN m32_fsdiv_callee

    ; divide sccz80 float by sccz80 float
    ;
    ; enter : stack = sccz80_float left, ret
    ;          DEHL = sccz80_float right
    ;
    ; exit  :  DEHL = sccz80_float(left/right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

DEFC  asm_divf = m32_fsdiv_callee       ; enter stack = d32_float left
                                        ;        DEHL = d32_float right
                                        ; return DEHL = d32_float
