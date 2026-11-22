
SECTION code_clib

PUBLIC sprite_set_composite


; void sprite_set_composite(struct sprite *spr);
sprite_set_composite:
    pop     af
    pop     hl
    push    hl
    push    af
    INCLUDE "target/zxn/sprites/z80/asm_sprite_set_composite.asm"

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sprite_set_composite
defc   _sprite_set_composite = sprite_set_composite
ENDIF
