
; float __fsmin (float number) __z88dk_fastcall

SECTION code_clib
SECTION code_math

PUBLIC asm_fsmin

EXTERN m32_fsmin_fastcall

    ; change underflow to a error floating zero as sdcc float
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  :  DEHL = sccz80_float(0)
    ;
    ; uses  : af, bc, de, hl

DEFC  asm_fsmin = m32_fsmin_fastcall            ; enter stack = ret
                                                ;        DEHL = d32_float
                                                ; return DEHL = d32_float
