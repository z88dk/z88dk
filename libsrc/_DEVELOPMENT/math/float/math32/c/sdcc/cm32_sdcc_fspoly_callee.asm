
; float __fspoly (const float x, const float d[], uint16_t n)

SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sdcc_fspoly_callee

EXTERN m32_fspoly_callee

.cm32_sdcc_fspoly_callee

    ; evaluation of a polynomial function
    ;
    ; enter : stack = float d[], float x, ret
    ;
    ; exit  : dehl  = 32-bit result
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    pop af                      ; my return
    pop hl                      ; (float)x
    pop de
    push af                     ; my return
    jp m32_fspoly_callee
