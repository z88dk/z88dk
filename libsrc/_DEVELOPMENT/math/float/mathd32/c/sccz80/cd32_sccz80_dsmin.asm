
; float __fsmin (float number)

SECTION code_clib
SECTION code_math

PUBLIC cd32_sccz80_dsmin

EXTERN md32_fsmin_fastcall

    ; change underflow to a error floating zero as sdcc float
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  :  DEHL = sccz80_float(0)
    ;
    ; uses  : af, bc, de, hl

DEFC  cd32_sccz80_dsmin = md32_fsmin_fastcall   ; enter stack = ret
                                                ;        DEHL = d32_float
                                                ; return DEHL = d32_float
