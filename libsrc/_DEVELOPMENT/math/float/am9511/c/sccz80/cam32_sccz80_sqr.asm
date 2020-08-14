

SECTION code_fp_am9511
PUBLIC cam32_sccz80_sqr

EXTERN asm_am9511_sqr_fastcall

    ; square (^2) sccz80 floats
    ;
    ; enter : stack = ret, DEHL = signed IEEE_float
    ;
    ; exit  :  DEHL = sccz80_float(number^2)
    ;
    ; uses  : af, bc, de, hl, af'

defc cam32_sccz80_sqr = asm_am9511_sqr_fastcall
