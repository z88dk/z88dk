

SECTION code_clib
PUBLIC asm_sprite_set_rotate

; Entry: hl = sprite
asm_sprite_set_rotate:
    inc     hl      ;attr1
    inc     hl      ;attr2
    set     1,(hl)
    ret
