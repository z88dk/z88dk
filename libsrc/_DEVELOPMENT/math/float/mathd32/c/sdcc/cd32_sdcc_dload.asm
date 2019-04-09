
SECTION code_clib
SECTION code_math

PUBLIC cd32_sdcc_dload

.cd32_sdcc_dload

    ; sdcc float primitive
    ; Load float pointed to by HL into BCDE
    ;
    ; Convert from sdcc_float format to d32 format.
    ;
    ; enter : HL = float * (sdcc_float)
    ;
    ; exit  : BCDE = float (sdcc_float)
    ;
    ; uses  : f, bc, de, hl

    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    ld c,(hl)
    inc hl
    ld b,(hl)                    ; BCDE = sdcc_float

    ret
