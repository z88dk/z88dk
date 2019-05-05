
; float __fsinv (float number)

SECTION code_clib
SECTION code_math

PUBLIC cm32_sdcc_fsinv

EXTERN cm32_sdcc_fsreadl, m32_fsinv_fastcall

.cm32_sdcc_fsinv

    ; negate sdcc floats
    ;
    ; enter : stack = sdcc_float number, ret
    ;
    ; exit  : DEHL = sdcc_float(1/number)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call cm32_sdcc_fsreadl

    jp m32_fsinv_fastcall   ; enter  DEHL = sdcc_float
                            ;
                            ; return DEHL = sdcc_float
