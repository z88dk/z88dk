
; float _asinf (float number) __z88dk_fastcall

SECTION code_clib
SECTION code_fp_am9511

PUBLIC asm_asinf

EXTERN asm_am9511_asin_fastcall

    ; square (^2) sccz80 float
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  :  DEHL = sccz80_float(asin(number))
    ;
    ; uses  : af, bc, de, hl, af'

DEFC  asm_asinf = asm_am9511_asin_fastcall      ; enter stack = ret
                                                ;        DEHL = IEEE-754 float
                                                ; return DEHL = IEEE-754 float
