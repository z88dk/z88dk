
; half __mul_callee (half left, half right)

SECTION code_fp_math16

PUBLIC cm16_sdcc_mul_callee

EXTERN cm16_sdcc_readr_callee
EXTERN asm_f16_mul_callee

.cm16_sdcc_mul_callee

    ; multiply two sdcc hal
    ;
    ; enter : stack = sdcc_half right, sdcc_half left, ret
    ;
    ; exit  :    HL = sdcc_half(left*right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call cm16_sdcc_readr_callee
    jp asm_f16_mul_callee   ; enter stack = sdcc_half left, ret
                            ;          HL = sdcc_half right
                            ; return   HL = sdcc_half
