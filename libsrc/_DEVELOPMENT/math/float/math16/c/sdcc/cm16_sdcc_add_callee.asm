
; half __add_callee (half left, half right)

SECTION code_fp_math16

PUBLIC cm16_sdcc_add_callee

EXTERN cm16_sdcc_readr_callee
EXTERN asm_f16_add_callee

.cm16_sdcc_add_callee

    ; add two sdcc halfs
    ;
    ; enter : stack = sdcc_half right, sdcc_half left, ret
    ;
    ; exit  :    HL = sdcc_half(left+right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call cm16_sdcc_readr_callee
    jp asm_f16_add_callee   ; enter stack = sdcc_half left, ret
                            ;          HL = sdcc_half right

