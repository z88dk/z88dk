
; half __sqrt (half number)

SECTION code_fp_math16

PUBLIC cm16_sdcc_sqrt

EXTERN cm16_sdcc_read1
EXTERN asm_f16_sqrt

.cm16_sdcc_sqrt

    ; square root sdcc half
    ;
    ; enter : stack = sdcc_half number, ret
    ;
    ; exit  :    HL = sdcc_half(number^0.5)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call cm16_sdcc_read1

    jp asm_f16_sqrt         ; enter  HL = sdcc_half
                            ;
                            ; return HL = sdcc_half
