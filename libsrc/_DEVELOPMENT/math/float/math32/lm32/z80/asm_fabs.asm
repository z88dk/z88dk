
SECTION code_fp_math32
PUBLIC  asm_fabs
EXTERN  m32_fabs_fastcall

    ; Takes the absolute value of a float
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  :  DEHL = |sccz80_float|
    ;
    ; uses  : bc, de, hl

defc asm_fabs = m32_fabs_fastcall
