
; float __fsneg_fastcall (float number)

SECTION code_clib
SECTION code_math

PUBLIC cd32_sdcc_dsneg_fastcall

EXTERN md32_fsneg_fastcall

    ; negate sdcc floats
    ;
    ; enter : stack = sdcc_float number, ret
    ;
    ; exit  : DEHL = sdcc_float(-number)
    ;
    ; uses  : af, bc, de, hl

DEFC cd32_sdcc_dsneg_fastcall = md32_fsneg_fastcall ; enter DEHL = sdcc_float
                                                    ;
                                                    ; return DEHL = sdcc_float
