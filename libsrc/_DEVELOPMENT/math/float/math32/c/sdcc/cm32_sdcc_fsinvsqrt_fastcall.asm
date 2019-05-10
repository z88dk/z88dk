
; float __fsinvsqrt_fastcall (float number)

SECTION code_clib
SECTION code_math

PUBLIC cm32_sdcc_fsinvsqrt_fastcall

EXTERN m32_fsinvsqrt_fastcall

    ; inverse square root of sdcc float
    ;
    ; enter : stack = sdcc_float number, ret
    ;
    ; exit  : DEHL = sdcc_float(number^0.5)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

DEFC cm32_sdcc_fsinvsqrt_fastcall = m32_fsinvsqrt_fastcall  ; enter DEHL = sdcc_float
                                                            ;
                                                            ; return DEHL = sdcc_float
