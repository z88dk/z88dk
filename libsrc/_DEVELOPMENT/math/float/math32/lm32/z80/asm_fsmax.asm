
; float __fsmax (float number) __z88dk_fastcall

SECTION code_clib
SECTION code_fp_math32

PUBLIC asm_fsmax

EXTERN m32_fsmax_fastcall

    ; convert sdcc float to infinity with correct sign
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  :  DEHL = sccz80_float(infinity)
    ;
    ; uses  : af, bc, de, hl

DEFC  asm_fsmax = m32_fsmax_fastcall            ; enter stack = ret
                                                ;        DEHL = d32_float
                                                ; return DEHL = d32_float
