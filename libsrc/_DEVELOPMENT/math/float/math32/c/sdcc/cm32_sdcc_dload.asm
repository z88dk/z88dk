
SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sdcc_dload

.cm32_sdcc_dload

    ; sdcc float primitive
    ; Load float pointed to by HL into DEHL'
    ;
    ; enter : HL = float* (sdcc_float)
    ;
    ; exit  : DEHL' = float (sdcc_float)
    ;         (exx set is swapped)
    ;
    ; uses  : bc, de, hl, bc', de', hl'

    ld c,(hl+)
    ld b,(hl+)
    ld e,(hl+)
    ld d,(hl)                   ; DEBC = sdcc_float

    ld hl,bc

    exx
    ret                         ; DEHL' = sdcc_float
