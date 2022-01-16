
SECTION code_clib
SECTION code_fp_am9511

PUBLIC asm_switch_arg


.asm_switch_arg
    ; Switch arguments
    ;
    ; Entry:
    ; Stack: left, right, ret1, ret0
    ;
    ; Exit:
    ; Stack: right, left, ret1
    ;
    ; Uses a, bc, de, hl

    ld hl,8         ; left
    add hl,sp
    ex de,hl
    ld hl,4         ; right
    add hl,sp
    ld b,4
.loop
    ld c,(hl)
    ld a,(de)
    ex de,hl
    ld (hl),c
    ld (de),a
    inc hl
    inc de
    djnz loop
    ret

