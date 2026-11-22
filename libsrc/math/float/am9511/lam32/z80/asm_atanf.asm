
; float _atanf (float number) __z88dk_fastcall

SECTION code_clib
SECTION code_fp_am9511

PUBLIC asm_atanf

EXTERN asm_am9511_atan_fastcall

    ; square (^2) sccz80 float
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  :  DEHL = sccz80_float(atan(number))
    ;
    ; uses  : af, bc, de, hl, af'

DEFC  asm_atanf = asm_am9511_atan_fastcall      ; enter stack = ret
                                                ;        DEHL = IEEE-754 float
                                                ; return DEHL = IEEE-754 float
