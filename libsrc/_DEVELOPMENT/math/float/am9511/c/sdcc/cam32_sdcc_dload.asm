
SECTION code_clib
SECTION code_fp_am9511

PUBLIC cam32_sdcc_dload

.cam32_sdcc_dload

    ; sdcc float primitive
    ; Load float pointed to by HL into DEHL'
    ;
    ; enter : HL = float* (sdcc_float)
    ;
    ; exit  : DEHL' = float (sdcc_float)
    ;         (exx set is swapped)
    ;
    ; uses  : bc, de, hl, bc', de', hl'

    ld c,(hl)
    inc hl
    ld b,(hl)
    inc hl
    ld e,(hl)
    inc hl
    ld d,(hl)                   ; DEBC = sdcc_float

    ld hl,bc

    exx
    ret                         ; DEHL' = sdcc_float
