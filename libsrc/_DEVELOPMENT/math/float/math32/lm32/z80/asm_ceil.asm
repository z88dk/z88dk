
SECTION code_fp_math32
PUBLIC  asm_ceil
EXTERN  m32_ceil_fastcall

    ; Takes the closest higher integer 
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  :  DEHL = ceil(sccz80_float)
    ;
    ; uses  : af, bc, de, hl

defc asm_ceil = m32_ceil_fastcall
