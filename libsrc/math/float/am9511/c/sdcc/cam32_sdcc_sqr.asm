
; float __sqr (float number)

SECTION code_clib
SECTION code_fp_am9511

PUBLIC cam32_sdcc_sqr

EXTERN asm_am9511_sqr

    ; square (^2) sdcc floats
    ;
    ; enter : stack = sdcc_float number, ret
    ;
    ; exit  : DEHL = sdcc_float(number^2)
    ;
    ; uses  : af, bc, de, hl, af'

defc cam32_sdcc_sqr = asm_am9511_sqr
