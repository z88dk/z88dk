

SECTION code_clib
PUBLIC asm_sprite_set_composite

; Entry: hl = sprite
asm_sprite_set_composite:
    inc     hl     ;attr1
    inc     hl      ;attr2
    inc     hl      ;attr3
    inc     hl      ;attr4
    res     5,(hl)
    ret

