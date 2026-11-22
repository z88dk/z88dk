
; float _div2f (float number) __z88dk_fastcall

SECTION code_clib
SECTION code_fp_math32

PUBLIC  asm_div2f

EXTERN  m32_fsdiv2_fastcall

    ; Divide a float by 2
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  : DEHL = sccz80_float/2
    ;
    ; uses  : de, hl

defc asm_div2f = m32_fsdiv2_fastcall
