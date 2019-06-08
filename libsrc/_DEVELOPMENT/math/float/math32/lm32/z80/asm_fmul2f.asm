
; float _mul2f (float number) __z88dk_fastcall

SECTION code_fp_math32

PUBLIC  asm_mul2f

EXTERN  m32_fsmul2_fastcall

    ; Multiply a float by 2
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  : DEHL = sccz80_float*2
    ;
    ; uses  : de, hl

defc asm_mul2f = m32_fsmul2_fastcall
