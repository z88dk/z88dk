
; float __fssqrt (float number)

SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sdcc_fssqrt

EXTERN m32_fssqrt

    ; square root sdcc float
    ;
    ; enter : stack = sdcc_float number, ret
    ;
    ; exit  : DEHL = sdcc_float(number^0.5)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

defc cm32_sdcc_fssqrt = m32_fssqrt
