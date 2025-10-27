
; float __fssqrt (float number)

SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sccz80_fssqrt

EXTERN m32_fssqrt

    ; square root sccz80 float
    ;
    ; enter : stack = sccz80_float number, ret
    ;
    ; exit  :  DEHL = sccz80_float(number^0.5)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

defc cm32_sccz80_fssqrt = m32_fssqrt
