
; float __sqrt (float number)

SECTION code_clib
SECTION code_fp_am9511

PUBLIC cam32_sdcc_sqrt

EXTERN asm_am9511_sqrt

    ; square root sdcc float
    ;
    ; enter : stack = sdcc_float number, ret
    ;
    ; exit  : DEHL = sdcc_float(number^0.5)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

defc cam32_sdcc_sqrt = asm_am9511_sqrt
