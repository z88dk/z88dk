
; float __fsneg (float number)

SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sdcc_fsneg

EXTERN cm32_sdcc_fsread1, m32_fsneg

.cm32_sdcc_fsneg

    ; negate sdcc floats
    ;
    ; enter : stack = sdcc_float number, ret
    ;
    ; exit  : DEHL = sdcc_float(-number)
    ;
    ; uses  : af, bc, de, hl

    call cm32_sdcc_fsread1

    jp m32_fsneg            ; enter stack = sdcc_float, ret
                            ;        DEHL = sdcc_float
                            ; return DEHL = sdcc_float
