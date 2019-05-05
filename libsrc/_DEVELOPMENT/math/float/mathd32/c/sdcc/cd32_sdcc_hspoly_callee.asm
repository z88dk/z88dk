
; float __fspoly (const float x, const float d[], uint16_t n)

SECTION code_clib
SECTION code_math

PUBLIC cd32_sdcc_dspoly_callee

EXTERN md32_fspoly_callee

.cd32_sdcc_dpoly

    ; evaluation of a polynomial function
    ;
    ; enter : stack = uint16_t n, float d[], float x, ret
    ;
    ; exit  : dehl  = 32-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'


DEFC cd32_sdcc_dspoly_callee = md32_fspoly_callee
