
; float __fszero (float number)

SECTION code_clib
SECTION code_math

PUBLIC cm32_sccz80_fszero

EXTERN m32_fszero_fastcall

    ; return a legal zero
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  :  DEHL = sccz80_float(0)
    ;
    ; uses  : af, bc, de, hl

DEFC  cm32_sccz80_fszero = m32_fszero_fastcall  ; enter stack = ret
                                                ;        DEHL = d32_float
                                                ; return DEHL = d32_float
