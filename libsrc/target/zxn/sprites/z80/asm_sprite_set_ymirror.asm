

SECTION code_clib
PUBLIC asm_sprite_set_ymirror

; Entry: hl = sprite
asm_sprite_set_ymirror:
    inc     hl      ;attr1
    inc     hl      ;attr2
    set     2,(hl)
    ret
