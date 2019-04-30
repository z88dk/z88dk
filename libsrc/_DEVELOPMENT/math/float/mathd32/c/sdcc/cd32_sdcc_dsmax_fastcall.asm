
; float __fsmax_fastcall (float number)

SECTION code_clib
SECTION code_math

PUBLIC cd32_sdcc_dsmax_fastcall

EXTERN md32_fsmax_fastcall

    ; convert sdcc float to infinity with correct sign
    ;
    ; enter : stack = sdcc_float number, ret
    ;
    ; exit  : DEHL = sdcc_float(infinity)
    ;
    ; uses  : af, bc, de, hl

DEFC cd32_sdcc_dsmax_fastcall = md32_fsmax_fastcall ; enter DEHL = sdcc_float
                                                    ;
                                                    ; return DEHL = sdcc_float
