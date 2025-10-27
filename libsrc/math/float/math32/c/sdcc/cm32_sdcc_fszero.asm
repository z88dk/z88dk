
; float __fszero (float number)

SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sdcc_fszero

EXTERN cm32_sdcc_fsread1, m32_fszero

.cm32_sdcc_fszero

    ; return a signed legal zero
    ;
    ; enter : stack = sdcc_float number, ret
    ;
    ; exit  : DEHL = sdcc_float(signed 0)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call cm32_sdcc_fsread1

    jp m32_fszero           ; enter stack = sdcc_float, ret
                            ;        DEHL = sdcc_float
                            ; return DEHL = sdcc_float
