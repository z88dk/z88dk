

SECTION code_clib
PUBLIC asm_sprite_unset_visible

; Entry: hl = sprite
asm_sprite_unset_visible:
    inc     hl      ;attr1
    inc     hl      ;attr2
    inc     hl      ;attr3
    res     7,(hl)
    ret
