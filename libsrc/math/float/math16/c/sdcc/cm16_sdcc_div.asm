; half __div (half left, half right)

SECTION code_clib
SECTION code_fp_math16

PUBLIC cm16_sdcc_div

EXTERN asm_f24_f16
EXTERN asm_f16_f24
EXTERN asm_f24_div_f24

EXTERN cm16_sdcc_readr

.cm16_sdcc_div

    ; divide sdcc half by sdcc half
    ;
    ; enter : stack = sdcc_half right, sdcc_half left, ret
    ;
    ; exit  : DEHL = sdcc_half(left/right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'
    ;
    ; asm_f24_div_f24 wants main = dividend x and alt = divisor y.
    ; asm_f24_f16 does not use exx, so y survives in the alt set.

    call cm16_sdcc_readr        ; HL = right = y

    call asm_f24_f16            ; y in main
    exx                         ; y in alt

    pop bc                      ; ret
    pop hl                      ; left = x half
    push hl
    push bc
    call asm_f24_f16            ; x in main
    call asm_f24_div_f24
    jp asm_f16_f24              ; return HL = sdcc_half
