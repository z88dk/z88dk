
; float _fdiv2 (float number) __z88dk_fastcall

SECTION code_clib
SECTION code_fp_am9511

PUBLIC  asm_fdiv2

EXTERN  asm_am9511_fdiv2_fastcall

    ; Divide a float by 2
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  : DEHL = sccz80_float/2
    ;
    ; uses  : de, hl

defc asm_fdiv2 = asm_am9511_fdiv2_fastcall
