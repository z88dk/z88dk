
; float _invsqrtf (float number) __z88dk_fastcall

SECTION code_clib
SECTION code_fp_math32

PUBLIC asm_invsqrtf

EXTERN m32_fsinvsqrt_fastcall

    ; inverse square root sccz80 float
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  :  DEHL = sccz80_float(1/number^0.5)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

DEFC  asm_invsqrtf = m32_fsinvsqrt_fastcall     ; enter stack = ret
                                                ;        DEHL = d32_float
                                                ; return DEHL = d32_float
