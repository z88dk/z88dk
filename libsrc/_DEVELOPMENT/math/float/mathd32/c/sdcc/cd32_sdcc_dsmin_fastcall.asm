
; float __fsmin_fastcall (float number)

SECTION code_clib
SECTION code_math

PUBLIC cd32_sdcc_dsmin_fastcall

EXTERN md32_fsmin_fastcall

    ; change underflow to a error floating zero as sdcc float
    ;
    ; enter : stack = sdcc_float number, ret
    ;
    ; exit  : DEHL = sdcc_float(0)
    ;
    ; uses  : af, bc, de, hl

DEFC cd32_sdcc_dsmin_fastcall = md32_fsmin_fastcall ; enter DEHL = sdcc_float
                                                    ;
                                                    ; return DEHL = sdcc_float
