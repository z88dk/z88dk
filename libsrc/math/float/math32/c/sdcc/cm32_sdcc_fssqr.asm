
; float __fssqr (float number)

SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sdcc_fssqr

EXTERN m32_fssqr

    ; square (^2) sdcc floats
    ;
    ; enter : stack = sdcc_float number, ret
    ;
    ; exit  : DEHL = sdcc_float(number^2)
    ;
    ; uses  : af, bc, de, hl, af'

defc cm32_sdcc_fssqr = m32_fssqr
