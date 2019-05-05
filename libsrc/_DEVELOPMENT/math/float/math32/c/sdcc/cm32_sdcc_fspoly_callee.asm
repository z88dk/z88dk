
; float __fspoly (const float x, const float d[], uint16_t n)

SECTION code_clib
SECTION code_math

PUBLIC cm32_sdcc_fspoly_callee

EXTERN m32_fspoly_callee

.cm32_sdcc_dpoly

    ; evaluation of a polynomial function
    ;
    ; enter : stack = uint16_t n, float d[], float x, ret
    ;
    ; exit  : dehl  = 32-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'


DEFC cm32_sdcc_fspoly_callee = m32_fspoly_callee
