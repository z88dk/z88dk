
SECTION code_clib
SECTION code_math

PUBLIC cd32_sccz80_dread

.cd32_sccz80_dread

    ; sccz80 float primitive
    ;
    ; Convert from sccz80_float format to d32_float.
    ;
    ; enter : DEHL = sccz80_float right
    ;
    ; exit  : BCDE = d32_float right
    ; 
    ; uses  : bc, de, hl

    ex de,hl
    ld b,h
    ld c,l
    ret                 ; return BCDE = d32_float

