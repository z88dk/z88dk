
; float _div2f (float number) __z88dk_fastcall

SECTION code_clib
SECTION code_fp_am9511

PUBLIC  asm_div2f

EXTERN  asm_am9511_fsdiv2_fastcall

    ; Divide a float by 2
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  : DEHL = sccz80_float/2
    ;
    ; uses  : de, hl

defc asm_div2f = asm_am9511_fsdiv2_fastcall
