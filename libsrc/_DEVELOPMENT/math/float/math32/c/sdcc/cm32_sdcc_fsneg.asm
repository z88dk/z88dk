
; float __fsneg (float number)

SECTION code_clib
SECTION code_math

PUBLIC cm32_sdcc_fsneg

EXTERN cm32_sdcc_fsreadl, m32_fsneg_fastcall

.cm32_sdcc_fsneg

    ; negate sdcc floats
    ;
    ; enter : stack = sdcc_float number, ret
    ;
    ; exit  : DEHL = sdcc_float(-number)
    ;
    ; uses  : af, bc, de, hl

    call cm32_sdcc_fsreadl

    jp m32_fsneg_fastcall   ; enter stack = sdcc_float, ret
                            ;        DEHL = sdcc_float
                            ; return DEHL = sdcc_float
