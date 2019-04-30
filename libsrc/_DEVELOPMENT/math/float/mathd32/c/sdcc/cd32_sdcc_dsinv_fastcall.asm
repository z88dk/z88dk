
; float __fsinv_fastcall (float number)

SECTION code_clib
SECTION code_math

PUBLIC cd32_sdcc_dsinv_fastcall

EXTERN md32_fsinv_fastcall

    ; negate sdcc floats
    ;
    ; enter : stack = sdcc_float number, ret
    ;
    ; exit  : DEHL = sdcc_float(1/number)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

DEFC cd32_sdcc_dsinv_fastcall =  md32_fsinv_fastcall    ; enter  DEHL = sdcc_float
                                                        ;
                                                        ; return DEHL = sdcc_float
