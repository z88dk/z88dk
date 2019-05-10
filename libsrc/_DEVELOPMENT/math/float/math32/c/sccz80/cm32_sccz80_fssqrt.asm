
; float __fssqrt (float number)

SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sccz80_fssqrt

EXTERN m32_fssqrt_fastcall

    ; square root sccz80 float
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  :  DEHL = sccz80_float(number^0.5)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

DEFC  cm32_sccz80_fssqrt = m32_fssqrt_fastcall          ; enter stack = ret
                                                        ;        DEHL = d32_float
                                                        ; return DEHL = d32_float
