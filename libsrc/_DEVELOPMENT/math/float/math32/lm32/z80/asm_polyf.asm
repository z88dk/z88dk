
; float _polyf (const float x, const float d[], uint16_t n) __z88dk_callee

SECTION code_clib
SECTION code_fp_math32

PUBLIC asm_polyf

EXTERN m32_fspoly_callee

    ; evaluation of a polynomial function
    ;
    ; enter : stack = uint16_t n, float d[], float x, ret
    ;
    ; exit  : dehl  = 32-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

DEFC  asm_polyf = m32_fspoly_callee             ; enter stack = ret
                                                ;        DEHL = d32_float
                                                ; return DEHL = d32_float

