
SECTION code_clib
SECTION code_fp_am9511

PUBLIC cam32_sccz80_readl
PUBLIC cam32_sccz80_read1

EXTERN cam32_sccz80_load

.cam32_sccz80_readl

    ; sccz80 float primitive
    ; Read right sccz80 float from the stack
    ;
    ; enter : stack = sccz80_float left, sccz80_float right, ret1, ret0
    ;
    ; exit  : stack = sccz80_float left, sccz80_float right, ret1
    ;          DEHL = sccz80_float right
    ; 
    ; uses  : af, bc, de, hl

    ld hl,8                     ; stack sccz80_float left
    add hl,sp

    jp cam32_sccz80_load        ; return DEHL = sccz80_float left


.cam32_sccz80_read1

    ; sccz80 float primitive
    ; Read left / single sccz80 float from the stack
    ;
    ; enter : stack = sccz80_float, ret1, ret0
    ;
    ; exit  : stack = sccz80_float, ret1
    ;          DEHL = sccz80_float
    ; 
    ; uses  : f, bc, de, hl

    ld hl,4                     ; stack sccz80_float
    add hl,sp

    jp cam32_sccz80_load        ; return DEHL = sccz80_float

