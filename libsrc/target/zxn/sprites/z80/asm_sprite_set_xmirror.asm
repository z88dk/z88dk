

SECTION code_clib
PUBLIC asm_sprite_set_xmirror

; Entry: hl = sprite
asm_sprite_set_xmirror:
    inc     hl      ;attr1
    inc     hl      ;attr2
    set     3,(hl)
    ret
