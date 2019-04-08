
SECTION code_clib
SECTION code_math

PUBLIC cd32_sdcciyp_dret

.cd32_sdcciyp_dret

    ; return d32_float to sdcc_float
    ;
    ; enter : BCDE = d32_float
    ;
    ; exit  : DEHL = sdcc_float
    ;
    ; uses  : bc, de, hl

    ld l,c
    ld h,b

    ex de,hl            ; HLDE = sdcc_float

    ret                 ; return DEHL = sdcc_float
