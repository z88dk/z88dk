
SECTION code_fp_math32
PUBLIC  asm_floor
EXTERN  m32_floor_fastcall

    ; Takes the closest higher integer 
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  :  DEHL = floor(sccz80_float)
    ;
    ; uses  : af, bc, de, hl

defc asm_floor = m32_floor_fastcall
