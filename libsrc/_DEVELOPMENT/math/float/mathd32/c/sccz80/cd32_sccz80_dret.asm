
SECTION code_clib
SECTION code_math

PUBLIC cd32_sccz80_dret

.cd32_sccz80_dret

    ; return d32_float to sccz80_float
    ;
    ; Convert from d32_float format to sccz80_float.
    ;
    ; enter : BCDE = d32_float
    ;
    ; exit  : DEHL = sccz80_float
    ;
    ; uses  : bc, de, hl

    ld l,c
    ld h,b
    ex de,hl
    ret                 ; return DEHL = sccz80_float
