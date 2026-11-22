

SECTION code_clib
PUBLIC asm_sprite_set_palette_offset

; Entry: hl = sprite
;         a = palette offset
asm_sprite_set_palette_offset:
    rlca
    rlca
    rlca
    rlca
    and     @11110000
    ld      c,a
    inc     hl      ;attr1
    inc     hl      ;attr2
    ld      a,(hl)
    and     @00001111
    or      c
    ld      (hl),a
    ret

