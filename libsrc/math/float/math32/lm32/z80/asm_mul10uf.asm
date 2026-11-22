
; float _mul10uf (float number) __z88dk_fastcall

SECTION code_clib
SECTION code_fp_math32

PUBLIC  asm_mul10uf

EXTERN  m32_mul10u_fastcall

    ; Multiply a float by 10, and make positive
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  :  DEHL = 10 * |sccz80_float|
    ;
    ; uses  : de, hl

defc asm_mul10uf = m32_mul10u_fastcall
