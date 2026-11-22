

SECTION code_clib
PUBLIC asm_sprite_set_y

; Entry: hl = sprite
;        bc = coordinate
asm_sprite_set_y:
    inc     hl     ;attr1
    ld      (hl),c
    inc     hl      ;attr2
    inc     hl      ;attr3
    inc     hl      ;attr4
    res     0,(hl)
    ld      a,b
    and     a
    ret     z
    set     0,(hl)
    ret

