
; half __invsqrt (half number)

SECTION code_fp_math16

PUBLIC cm16_sdcc_invsqrt

EXTERN cm16_sdcc_read1
EXTERN asm_f16_invsqrt

.cm16_sdcc_invsqrt

    ; inverse square root sdcc half
    ;
    ; enter : stack = sdcc_half number, ret
    ;
    ; exit  :    HL = sdcc_half(1/number^0.5)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call cm16_sdcc_read1

    jp asm_f16_invsqrt      ; enter  HL = sdcc_half
                            ;
                            ; return HL = sdcc_half
