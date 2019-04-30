
; float __fszero_fastcall (float number)

SECTION code_clib
SECTION code_math

PUBLIC cd32_sdcc_dszero_fastcall

EXTERN md32_fszero_fastcall

    ; return a legal zero
    ;
    ; enter : stack = sdcc_float number, ret
    ;
    ; exit  : DEHL = sdcc_float(0)
    ;
    ; uses  : af, bc, de, hl

DEFC cd32_sdcc_dszero_fastcall = md32_fszero_fastcall   ; enter DEHL = sdcc_float
                                                        ;
                                                        ; return DEHL = sdcc_float
