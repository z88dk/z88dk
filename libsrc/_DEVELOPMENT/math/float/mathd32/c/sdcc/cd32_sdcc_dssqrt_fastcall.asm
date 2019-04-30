
; float __fssqrt_fastcall (float number)

SECTION code_clib
SECTION code_math

PUBLIC cd32_sdcc_dssqrt_fastcall

EXTERN md32_fssqrt_fastcall

    ; square root of sdcc float
    ;
    ; enter : stack = sdcc_float number, ret
    ;
    ; exit  : DEHL = sdcc_float(number^0.5)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

DEFC cd32_sdcc_dssqrt_fastcall = md32_fssqrt_fastcall   ; enter DEHL = sdcc_float
                                                        ;
                                                        ; return DEHL = sdcc_float
