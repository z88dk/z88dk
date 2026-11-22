
SECTION code_clib

PUBLIC sprite_set_4bit_high


; void sprite_set_4bit_high(struct sprite *spr);
sprite_set_4bit_high:
    pop     af
    pop     hl
    push    hl
    push    af
    INCLUDE "target/zxn/sprites/z80/asm_sprite_set_4bit_high.asm"

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sprite_set_4bit_high
defc   _sprite_set_4bit_high = sprite_set_4bit_high
ENDIF
