

SECTION code_clib
PUBLIC asm_sprite_set_x

; Entry: hl = sprite
;        bc = coordinate
asm_sprite_set_x:
    ld      (hl),c
    inc     hl      ;attr1
    inc     hl      ;attr2
    res     0,(hl)
    ld      a,b
    and     a
    ret     z
    set     0,(hl)
    ret

