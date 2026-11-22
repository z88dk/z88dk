

SECTION code_clib
PUBLIC asm_sprite_unset_xmirror

; Entry: hl = sprite
asm_sprite_unset_xmirror:
    inc     hl      ;attr1
    inc     hl      ;attr2
    res     3,(hl)
    ret
