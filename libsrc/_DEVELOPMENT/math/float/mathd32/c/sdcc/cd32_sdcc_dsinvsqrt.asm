
; float __fsinvsqrt (float number)

SECTION code_clib
SECTION code_math

PUBLIC cd32_sdcc_dsinvsqrt

EXTERN cd32_sdcc_dreadl, md32_fsinvsqrt_fastcall

.cd32_sdcc_dsinvsqrt

    ; square root of sdcc float
    ;
    ; enter : stack = sdcc_float number, ret
    ;
    ; exit  : DEHL = sdcc_float(number^0.5)
    ;
    ; uses  : af, bc, de, hl

    call cd32_sdcc_dreadl

    jp md32_fsinvsqrt_fastcall  ; enter DEHL = sdcc_float
                                ;
                                ; return DEHL = sdcc_float
