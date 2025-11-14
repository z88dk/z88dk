
; float _sqrtf (float number) __z88dk_fastcall

SECTION code_clib
SECTION code_fp_am9511

PUBLIC asm_sqrtf

EXTERN asm_am9511_sqrt_fastcall

    ; square root sccz80 float
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  :  DEHL = sccz80_float(number^0.5)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

DEFC  asm_sqrtf = asm_am9511_sqrt_fastcall      ; enter stack = ret
                                                ;        DEHL = IEEE-754 float
                                                ; return DEHL = IEEE-754 float
