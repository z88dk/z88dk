

SECTION code_clib
PUBLIC asm_sprite_unset_rotate

; Entry: hl = sprite
asm_sprite_unset_rotate:
    inc     hl      ;attr1
    inc     hl      ;attr2
    res     1,(hl)
    ret
