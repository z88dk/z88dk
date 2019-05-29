
; float __fsmul (float left, float right)

SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sdcc_fsmul

EXTERN cm32_sdcc_fsreadr, m32_fsmul

.cm32_sdcc_fsmul

    ; multiply two sdcc floats
    ;
    ; enter : stack = sdcc_float right, sdcc_float left, ret
    ;
    ; exit  : DEHL = sdcc_float(left*right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call cm32_sdcc_fsreadr
    jp m32_fsmul            ; enter stack = sdcc_float right, sdcc_float left, ret
                            ;        DEHL = sdcc_float right
                            ; return DEHL = sdcc_float
