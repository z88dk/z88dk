
SECTION code_clib

PUBLIC sprite_set_4bit


; void sprite_set_4bit(struct sprite *spr);
sprite_set_4bit:
    pop     af
    pop     hl
    push    hl
    push    af
    INCLUDE "target/zxn/sprites/z80/asm_sprite_set_4bit.asm"

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sprite_set_4bit
defc   _sprite_set_4bit = sprite_set_4bit
ENDIF
