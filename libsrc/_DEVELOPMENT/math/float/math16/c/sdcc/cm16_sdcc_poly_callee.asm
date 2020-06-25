
; half_t __poly (const half_t x, const float_t d[], uint16_t n)

SECTION code_fp_math16

PUBLIC cm16_sdcc_poly_callee

EXTERN asm_f16_poly_callee

    ; evaluation of a polynomial function
    ;
    ; enter : stack = uint16_t n, float d[], half_t x, ret
    ;
    ; exit  : hl    = 16-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'


DEFC cm16_sdcc_poly_callee = asm_f16_poly_callee
