
; float _negf (float number) __z88dk_fastcall

SECTION code_clib
SECTION code_fp_math32

PUBLIC asm_negf

EXTERN m32_fsneg

    ; negate sccz80 floats
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  :  DEHL = sccz80_float(-number)
    ;
    ; uses  : af, bc, de, hl

DEFC  asm_negf = m32_fsneg                      ; enter stack = ret
                                                ;        DEHL = d32_float
                                                ; return DEHL = d32_float

