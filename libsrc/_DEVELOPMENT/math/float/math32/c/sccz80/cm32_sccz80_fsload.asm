

SECTION code_fp_math32

PUBLIC cm32_sccz80_fsload

.cm32_sccz80_fsload

    ; sccz80 float primitive
    ; Load float pointed to by HL into DEHL
    ;
    ; enter : HL = float* (sccz80_float)
    ;
    ; exit  : DEHL = float (sccz80_float)
    ;
    ; uses  : f, bc, de, hl

    ld c,(hl)
    inc hl
    ld b,(hl)
    inc hl
    ld e,(hl)
    inc hl
    ld d,(hl)                   ; DEBC = sccz80_float

    ld l,c
    ld h,b

    ret                         ; DEHL = sccz80_float
