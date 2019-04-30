
; float __fsmax (float number)

SECTION code_clib
SECTION code_math

PUBLIC cd32_sdcc_dsmax

EXTERN cd32_sdcc_dreadl, md32_fsmax_fastcall

.cd32_sdcc_dsmax

    ; convert sdcc float to infinity with correct sign
    ;
    ; enter : stack = sdcc_float number, ret
    ;
    ; exit  : DEHL = sdcc_float(infinity)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call cd32_sdcc_dreadl

    jp md32_fsmax_fastcall  ; enter stack = sdcc_float, ret
                            ;        DEHL = sdcc_float
                            ; return DEHL = sdcc_float
