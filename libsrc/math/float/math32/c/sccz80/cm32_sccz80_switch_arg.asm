

SECTION code_fp_math32
PUBLIC cm32_sccz80_switch_arg


.cm32_sccz80_switch_arg
    ; Switch arguments from SmallC to SDCC order
    ;
    ; Entry:
    ; Stack: sccz80 left, sccz80 right, ret1, ret0
    ;
    ; Exit:
    ; Stack: sccz80 right, sccz80 left, ret1
    ;
    ; Uses de, hl, bc, a
    ld hl,8         ;Left
    add hl,sp
    ex de,hl
    ld hl,4         ;Right
    add hl,sp
    ld b,4
.loop
    ld c,(hl)
    ld a,(de)
    ld (hl),a
    ld a,c
    ld (de),a
    inc de
    inc hl
    djnz loop
    ret

