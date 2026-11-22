

SECTION code_clib
PUBLIC asm_sprite_set_4bit

; Entry: hl = sprite
asm_sprite_set_4bit:
    inc     hl     ;attr1
    inc     hl      ;attr2
    inc     hl      ;attr3
    inc     hl      ;attr4
    set     7,(hl)
    ret

