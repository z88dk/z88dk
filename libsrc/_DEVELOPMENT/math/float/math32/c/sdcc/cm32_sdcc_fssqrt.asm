
; float __fssqrt (float number)

SECTION code_clib
SECTION code_math

PUBLIC cm32_sdcc_fssqrt

EXTERN cm32_sdcc_fsreadl, m32_fssqrt

.cm32_sdcc_fssqrt

    ; square root of sdcc float
    ;
    ; enter : stack = sdcc_float number, ret
    ;
    ; exit  : DEHL = sdcc_float(number^0.5)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call cm32_sdcc_fsreadl

    jp m32_fssqrt           ; enter stack = sdcc_float, ret
                            ;
                            ; return DEHL = sdcc_float
