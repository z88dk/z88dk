
; float __fsmax (float number)

SECTION code_clib
SECTION code_math

PUBLIC cm32_sdcc_fsmax

EXTERN cm32_sdcc_fsreadl, m32_fsmax_fastcall

.cm32_sdcc_fsmax

    ; convert sdcc float to infinity with correct sign
    ;
    ; enter : stack = sdcc_float number, ret
    ;
    ; exit  : DEHL = sdcc_float(infinity)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call cm32_sdcc_fsreadl

    jp m32_fsmax_fastcall   ; enter stack = sdcc_float, ret
                            ;        DEHL = sdcc_float
                            ; return DEHL = sdcc_float
