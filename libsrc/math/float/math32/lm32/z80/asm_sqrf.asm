
; float _sqrf (float number) __z88dk_fastcall

SECTION code_clib
SECTION code_fp_math32

PUBLIC asm_sqrf

EXTERN m32_fssqr_fastcall

    ; square (^2) sccz80 float
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  :  DEHL = sccz80_float(number^2)
    ;
    ; uses  : af, bc, de, hl, af'

DEFC  asm_sqrf = m32_fssqr_fastcall             ; enter stack = ret
                                                ;        DEHL = d32_float
                                                ; return DEHL = d32_float
