
SECTION code_clib

PUBLIC sprite_unset_4bit


; void sprite_unset_4bit(struct sprite *spr);
sprite_unset_4bit:
    pop     af
    pop     hl
    push    hl
    push    af
    INCLUDE "target/zxn/sprites/z80/asm_sprite_unset_4bit.asm"

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sprite_unset_4bit
defc   _sprite_unset_4bit = sprite_unset_4bit
ENDIF
