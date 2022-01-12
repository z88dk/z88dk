

SECTION code_fp_am9511

PUBLIC asm_sccz80_load

.asm_sccz80_load

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

    ld hl,bc

    ret                         ; DEHL = sccz80_float

