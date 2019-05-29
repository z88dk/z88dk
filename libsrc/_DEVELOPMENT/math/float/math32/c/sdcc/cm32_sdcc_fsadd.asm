
; float __fsadd (float left, float right)

SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sdcc_fsadd

EXTERN cm32_sdcc_fsreadr, m32_fsadd

.cm32_sdcc_fsadd

    ; add two sdcc floats
    ;
    ; enter : stack = sdcc_float right, sdcc_float left, ret
    ;
    ; exit  : DEHL = sdcc_float(left+right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call cm32_sdcc_fsreadr
    jp m32_fsadd            ; enter stack = sdcc_float right, sdcc_float left, ret
                            ;        DEHL = sdcc_float right
                            ; return DEHL = sdcc_float
