

SECTION code_clib
PUBLIC asm_sprite_set_yscale

; Entry: hl = sprite
;         a = scale
asm_sprite_set_yscale:
    rlca
    and     @00000110
    ld      c,a
    inc     hl      ;attr1
    inc     hl      ;attr2
    inc     hl      ;attr3
    inc     hl      ;attr4
    ld      a,(hl)
    and     @11111001
    or      c
    ld      (hl),a
    ret
