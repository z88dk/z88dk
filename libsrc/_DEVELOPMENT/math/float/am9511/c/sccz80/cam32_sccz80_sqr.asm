
; float __fssqr (float number)

SECTION code_clib
SECTION code_fp_am9511

PUBLIC cam32_sccz80_sqr

EXTERN asm_am9511_sqr

    ; square (^2) sccz80 floats
    ;
    ; enter : stack = sccz80_float number, ret
    ;
    ; exit  :  DEHL = sccz80_float(number^2)
    ;
    ; uses  : af, bc, de, hl, af'

defc cam32_sccz80_sqr = asm_am9511_sqr
