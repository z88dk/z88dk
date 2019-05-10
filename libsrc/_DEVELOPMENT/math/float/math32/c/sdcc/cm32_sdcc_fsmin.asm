
; float __fsmin (float number)

SECTION code_clib
SECTION code_math

PUBLIC cm32_sdcc_fsmin

EXTERN cm32_sdcc_fsreadl, m32_fsmin_fastcall

.cm32_sdcc_fsmin

    ; change underflow to a error floating zero as sdcc float
    ;
    ; enter : stack = sdcc_float number, ret
    ;
    ; exit  : DEHL = sdcc_float(0)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call cm32_sdcc_fsreadl

    jp m32_fsmin_fastcall   ; enter DEHL = sdcc_float
                            ;
                            ; return DEHL = sdcc_float
