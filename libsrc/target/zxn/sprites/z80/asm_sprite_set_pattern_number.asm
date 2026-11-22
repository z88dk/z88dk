

SECTION code_clib
PUBLIC asm_sprite_set_pattern_number

; Entry: hl = sprite
;         a = pattern number
asm_sprite_set_pattern_number:
    and     63
    ld      c,a
    inc     hl      ;attr1
    inc     hl      ;attr2
    inc     hl      ;attr3
    ld      a,(hl)
    and     @11000000
    or      c
    ld      (hl),a
    ret

