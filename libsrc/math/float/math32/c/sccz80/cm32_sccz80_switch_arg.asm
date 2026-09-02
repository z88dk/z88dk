

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
    ; HL is reloaded after the pair move — do not use ex de,hl on gbz80 (56c).
IF __CPU_GBZ80__
    ld hl,sp+8                      ; left
    ld de,hl
    ld hl,sp+4                      ; right
ELIF __CPU_8085__
    ld de,sp+8                      ; left
    ex de,hl
    ld de,sp+4                      ; right
    ex de,hl                        ; DE = left, HL = right
ELSE
    ld hl,8                         ;Left
    add hl,sp
    ex de,hl
    ld hl,4                         ;Right
    add hl,sp
ENDIF
    ld b,4
.loop
    ld c,(hl)
    ld a,(de)
    ld (hl+),a                      ; (de) → (hl)
    ld a,c
    ld (de+),a                      ; saved (hl) → (de); (de) is A-only
    djnz loop
    ret

