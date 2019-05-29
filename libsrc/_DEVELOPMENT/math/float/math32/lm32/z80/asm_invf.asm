
; float _invf (float number) __z88dk_fastcall

SECTION code_clib
SECTION code_fp_math32

PUBLIC asm_invf

EXTERN m32_fsinv_fastcall

    ; invert sccz80 float
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  :  DEHL = sccz80_float(1/number)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

DEFC  asm_invf = m32_fsinv_fastcall             ; enter stack = ret
                                                ;        DEHL = d32_float
                                                ; return DEHL = d32_float
