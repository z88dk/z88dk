
; float __fszero (float number)

SECTION code_clib
SECTION code_math

PUBLIC cd32_sccz80_dszero

EXTERN md32_fszero_fastcall

    ; return a legal zero
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  :  DEHL = sccz80_float(0)
    ;
    ; uses  : af, bc, de, hl

DEFC  cd32_sccz80_dszero = md32_fszero_fastcall ; enter stack = ret
                                                ;        DEHL = d32_float
                                                ; return DEHL = d32_float
