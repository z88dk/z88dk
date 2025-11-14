
; half_t __poly (const half_t x, const float_t d[], uint16_t n)

SECTION code_fp_math16

PUBLIC cm16_sdcc_poly

EXTERN asm_f16_poly


.cm16_sdcc_poly

    ; evaluation of a polynomial function
    ;
    ; enter : stack = uint16_t n, float d[], half_t x, ret
    ;
    ; exit  : hl    = 16-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    pop af                      ; my return
    pop hl                      ; (half_t)x
    exx

    pop hl                      ; (float*)d
    pop de                      ; (uint16_t)n
    push af                     ; my return

    call asm_f16_poly

    pop bc                      ; my return
    push bc
    push bc
    push bc
    push bc
    ret

