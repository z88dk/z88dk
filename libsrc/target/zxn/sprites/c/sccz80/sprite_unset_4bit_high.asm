
SECTION code_clib

PUBLIC sprite_unset_4bit_high


; void sprite_unset_4bit_high(struct sprite *spr);
sprite_unset_4bit_high:
    pop     af
    pop     hl
    push    hl
    push    af
    INCLUDE "target/zxn/sprites/z80/asm_sprite_unset_4bit_high.asm"

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sprite_unset_4bit_high
defc   _sprite_unset_4bit_high = sprite_unset_4bit_high
ENDIF
