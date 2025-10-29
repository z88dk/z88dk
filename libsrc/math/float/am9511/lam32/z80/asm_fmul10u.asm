
; float _fmul10u (float number) __z88dk_fastcall

SECTION code_clib
SECTION code_fp_am9511

PUBLIC  asm_fmul10u

EXTERN  asm_am9511_fmul10u_fastcall

    ; Multiply a float by 10, and make positive
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  :  DEHL = 10 * |sccz80_float|
    ;
    ; uses  : de, hl

defc asm_fmul10u = asm_am9511_fmul10u_fastcall
