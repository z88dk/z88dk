
; float _fabsf (float number) __z88dk_fastcall

SECTION code_clib
SECTION code_fp_math32

PUBLIC  asm_fabsf

EXTERN  m32_fabs_fastcall

    ; Takes the absolute value of a float
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  :  DEHL = |sccz80_float|
    ;
    ; uses  : de, hl

defc asm_fabsf = m32_fabs_fastcall
