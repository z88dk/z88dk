
; half __inv (half number)

SECTION code_fp_math16

PUBLIC cm16_sdcc_inv

EXTERN cm16_sdcc_read1
EXTERN asm_f16_inv

.cm16_sdcc_inv

    ; invert sdcc half
    ;
    ; enter : stack = sdcc_half number, ret
    ;
    ; exit  :    HL = sdcc_half(1/number)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call cm16_sdcc_read1

    jp asm_f16_inv          ; enter  HL = sdcc_half
                            ;
                            ; return HL = sdcc_half
