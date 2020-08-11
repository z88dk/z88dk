

SECTION code_fp_am9511

PUBLIC cam32_sccz80_dload

.cam32_sccz80_dload

    ; sccz80 float primitive
    ; Load float pointed to by HL into DEHL'.
    ;
    ; enter : HL = float* (sccz80_float)
    ;
    ; exit  : DEHL' = float (sccz80_float)
    ;         (exx set is swapped)
    ;
    ; uses  : bc, de, hl, bc', de', hl'

    ld c,(hl)
    inc hl
    ld b,(hl)
    inc hl
    ld e,(hl)
    inc hl
    ld d,(hl)                   ; DEBC = sccz80_float

    ld l,c
    ld h,b

    exx
    ret                         ; DEHL' = sccz80_float
