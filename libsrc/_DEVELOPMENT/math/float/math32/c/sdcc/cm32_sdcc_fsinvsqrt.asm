
; float __fsinvsqrt (float number)

SECTION code_clib
SECTION code_math

PUBLIC cm32_sdcc_fsinvsqrt

EXTERN cm32_sdcc_fsreadl, m32_fsinvsqrt_fastcall

.cm32_sdcc_fsinvsqrt

    ; inverse square root of sdcc float
    ;
    ; enter : stack = sdcc_float number, ret
    ;
    ; exit  : DEHL = sdcc_float(1/number^0.5)
    ;
    ; uses  : af, bc, de, hl

    call cm32_sdcc_fsreadl

    jp m32_fsinvsqrt_fastcall   ; enter DEHL = sdcc_float
                                ;
                                ; return DEHL = sdcc_float
