

SECTION code_clib
PUBLIC asm_sprite_set_xscale

; Entry: hl = sprite
;         a = scale
asm_sprite_set_xscale:
    rlca
    rlca
    rlca
    and     @00011000
    ld      c,a
    inc     hl      ;attr1
    inc     hl      ;attr2
    inc     hl      ;attr3
    inc     hl      ;attr4
    ld      a,(hl)
    and     @11100111
    or      c
    ld      (hl),a
    ret
