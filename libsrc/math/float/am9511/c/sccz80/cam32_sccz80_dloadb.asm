
SECTION code_clib
SECTION code_fp_am9511

PUBLIC cam32_sccz80_dloadb

.cam32_sccz80_dloadb

    ; sccz80 float primitive
    ; Load float given pointer in HL pointing to last byte into DEHL'.
    ;
    ; enter : HL = double * (sccz80 format) + 3 bytes
    ;
    ; exit  : DEHL'= double (IEEE-754 format)
    ;         (exx set is swapped)
    ;
    ; uses  : bc, de, hl, bc', de', hl'

    ld d,(hl)
    dec hl
    ld e,(hl)
    dec hl
    ld b,(hl)
    dec hl
    ld l,(hl)
    ld h,b

    exx
    ret
