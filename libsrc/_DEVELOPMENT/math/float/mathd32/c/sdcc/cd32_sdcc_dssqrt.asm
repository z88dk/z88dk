
; float __fssqrt (float number)

SECTION code_clib
SECTION code_math

PUBLIC cd32_sdcc_dssqrt

EXTERN cd32_sdcc_dreadl, md32_fssqrt_fastcall

.cd32_sdcc_dssqrt

    ; square root of sdcc float
    ;
    ; enter : stack = sdcc_float number, ret
    ;
    ; exit  : DEHL = sdcc_float(number^0.5)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call cd32_sdcc_dreadl

    jp md32_fssqrt_fastcall ; enter DEHL = sdcc_float
                            ;
                            ; return DEHL = sdcc_float
