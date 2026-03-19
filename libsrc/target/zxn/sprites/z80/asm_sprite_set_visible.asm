

SECTION code_clib
PUBLIC asm_sprite_set_visible

; Entry: hl = sprite
asm_sprite_set_visible:
    inc     hl      ;attr1
    inc     hl      ;attr2
    inc     hl      ;attr3
    set     7,(hl)
    ret
