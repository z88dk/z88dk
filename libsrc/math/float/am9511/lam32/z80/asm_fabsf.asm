
; float _fabsf (float number) __z88dk_fastcall

SECTION code_clib
SECTION code_fp_am9511

PUBLIC  asm_fabsf

EXTERN  asm_am9511_fabs_fastcall

    ; Takes the absolute value of a float
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  :  DEHL = |sccz80_float|
    ;
    ; uses  : de, hl

defc asm_fabsf = asm_am9511_fabs_fastcall
