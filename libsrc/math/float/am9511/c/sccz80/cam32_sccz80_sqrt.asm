

SECTION code_fp_am9511
PUBLIC cam32_sccz80_sqrt

EXTERN asm_am9511_sqrt_fastcall

    ; square root sccz80 float
    ;
    ; enter : stack = ret, DEHL = signed IEEE_float
    ;
    ; exit  :  DEHL = sccz80_float(number^0.5)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

defc cam32_sccz80_sqrt = asm_am9511_sqrt_fastcall
