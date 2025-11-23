
; float __fssqr (float number)

SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sccz80_fssqr

EXTERN m32_fssqr

    ; square (^2) sccz80 floats
    ;
    ; enter : stack = sccz80_float number, ret
    ;
    ; exit  :  DEHL = sccz80_float(number^2)
    ;
    ; uses  : af, bc, de, hl, af'

defc cm32_sccz80_fssqr = m32_fssqr
