
SECTION code_clib
SECTION code_fp_am9511

PUBLIC asm_sccz80_readl
PUBLIC asm_sccz80_read1

PUBLIC asm_sdcc_readr
PUBLIC asm_sdcc_read1

EXTERN asm_load

.asm_sccz80_readl

    ; sccz80 float primitive
    ; Read right sccz80 float from the stack
    ;
    ; enter : stack = sccz80_float left, sccz80_float right, ret1, ret0
    ;
    ; exit  : stack = sccz80_float left, sccz80_float right, ret1
    ;          DEHL = sccz80_float right
    ; 
    ; uses  : af, bc, de, hl

.asm_sdcc_readr

    ; sdcc float primitive
    ; Read right sdcc float from the stack
    ;
    ; Convert from sdcc_float calling to d32_float.
    ;
    ; enter : stack = sdcc_float right, sdcc_float left, ret1, ret0
    ;
    ; exit  : stack = sdcc_float right, sdcc_float left, ret1
    ;          DEHL = sdcc_float right
    ; 
    ; uses  : f, bc, de, hl

    ld de,sp+8                  ; stack sccz80_float left or sdcc_float right
    ex de,hl

    jp asm_load                 ; return DEHL


.asm_sccz80_read1

    ; sccz80 float primitive
    ; Read left / single sccz80 float from the stack
    ;
    ; enter : stack = sccz80_float, ret1, ret0
    ;
    ; exit  : stack = sccz80_float, ret1
    ;          DEHL = sccz80_float
    ; 
    ; uses  : f, bc, de, hl

.asm_sdcc_read1

    ; sdcc float primitive
    ; Read left / single sdcc float from the stack
    ;
    ; Convert from sdcc_float calling to d32_float.
    ;
    ; enter : stack = sdcc_float, ret1, ret0
    ;
    ; exit  : stack = sdcc_float, ret1
    ;          DEHL = sdcc_float
    ; 
    ; uses  : f, bc, de, hl

    ld de,sp+4                  ; stack sccz80_float or sdcc_float
    ex de,hl

    jp asm_load                 ; return DEHL

