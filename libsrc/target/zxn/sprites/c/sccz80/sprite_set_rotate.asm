
SECTION code_clib

PUBLIC sprite_set_rotate


; void sprite_set_rotate(struct sprite *spr);
sprite_set_rotate:
    pop     af
    pop     hl
    push    hl
    push    af
    INCLUDE "target/zxn/sprites/z80/asm_sprite_set_rotate.asm"

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sprite_set_rotate
defc   _sprite_set_rotate = sprite_set_rotate
ENDIF
