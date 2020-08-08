
; float _mul2f (float number) __z88dk_fastcall

SECTION code_clib
SECTION code_fp_am9511

PUBLIC  asm_mul2f

EXTERN  asm_am9511_mul2_fastcall

    ; Multiply a float by 2
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  :  DEHL = 2 * sccz80_float
    ;
    ; uses  : de, hl

defc asm_mul2f = asm_am9511_mul2_fastcall
