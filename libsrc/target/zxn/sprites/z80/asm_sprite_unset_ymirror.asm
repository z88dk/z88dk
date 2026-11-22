

SECTION code_clib
PUBLIC asm_sprite_unset_ymirror

; Entry: hl = sprite
asm_sprite_unset_ymirror:
    inc     hl      ;attr1
    inc     hl      ;attr2
    res     2,(hl)
    ret
