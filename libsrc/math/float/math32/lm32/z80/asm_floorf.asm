
; float _floorf (float number) __z88dk_fastcall

SECTION code_clib
SECTION code_fp_math32

PUBLIC  asm_floorf

EXTERN  m32_floor_fastcall

    ; Takes the closest lower integer 
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  :  DEHL = floor(sccz80_float)
    ;
    ; uses  : af, bc, de, hl

defc asm_floorf = m32_floor_fastcall
