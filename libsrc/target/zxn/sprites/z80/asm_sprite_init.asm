

SECTION code_clib

PUBLIC asm_sprite_init


; Entry: hl = sprite
asm_sprite_init:
    ld      (hl),0      ;attr0
    inc     hl
    ld      (hl),0      ;attr1
    inc     hl
    ld      (hl),0      ;attr2
    inc     hl
    ld      (hl),64     ;attr3. (set extended flag)
    inc     hl
    ld      (hl),0      ;attr4
    ret