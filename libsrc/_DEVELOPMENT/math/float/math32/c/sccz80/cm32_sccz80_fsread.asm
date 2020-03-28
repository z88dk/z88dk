
SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sccz80_fsreadl
PUBLIC cm32_sccz80_fsread1

EXTERN cm32_sccz80_fsload

.cm32_sccz80_fsreadl

    ; sccz80 float primitive
    ; Read right sccz80 float from the stack
    ;
    ; Convert from sccz80_float calling to d32_float.
    ;
    ; enter : stack = sccz80_float left, sccz80_float right, ret1, ret0
    ;
    ; exit  : stack = sccz80_float left, sccz80_float right, ret1
    ;          DEHL = sccz80_float right
    ; 
    ; uses  : af, bc, de, hl

    ld hl,8                     ; stack sccz80_float left
    add hl,sp

    jp cm32_sccz80_fsload         ; return DEHL = sccz80_float left


.cm32_sccz80_fsread1

    ; sccz80 float primitive
    ; Read left / single sccz80 float from the stack
    ;
    ; Convert from sccz80_float calling to d32_float.
    ;
    ; enter : stack = sccz80_float, ret1, ret0
    ;
    ; exit  : stack = sccz80_float, ret1
    ;          DEHL = sccz80_float
    ; 
    ; uses  : f, bc, de, hl

    ld hl,4                     ; stack sccz80_float
    add hl,sp

    jp cm32_sccz80_fsload         ; return DEHL = sccz80_float
