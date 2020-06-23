
; half_t __poly (const half_t x, const float_t d[], uint16_t n)

SECTION code_fp_math16

PUBLIC cm16_sccz80_poly

EXTERN asm_f16_poly


.cm16_sccz80_poly

    ; evaluation of a polynomial function
    ;
    ; enter : stack = half_t x, float_t d[], uint16_t n, ret
    ;
    ; exit  : hl    = 16-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    pop af                      ; my return
    pop hl                      ; (uint16_t)n
    pop de                      ; (float*)d
    exx

    pop hl                      ; (half_t)x
    exx

    push af                     ; my return
    push hl                     ; (uint16_t)n
    push de                     ; (float*)d
    exx

    push hl                     ; (half_t)x
    call asm_f16_poly

    pop af                      ; my return
    push af
    push af
    push af
    push af
    ret

