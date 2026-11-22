
; float _zerof (float number) __z88dk_fastcall

SECTION code_clib
SECTION code_fp_math32

PUBLIC asm_zerof

EXTERN m32_fszero_fastcall

    ; return a legal zero
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  :  DEHL = sccz80_float(0)
    ;
    ; uses  : af, bc, de, hl

DEFC  asm_zerof = m32_fszero_fastcall           ; enter stack = ret
                                                ;        DEHL = d32_float
                                                ; return DEHL = d32_float
