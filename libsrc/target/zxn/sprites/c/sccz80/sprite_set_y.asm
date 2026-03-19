
SECTION code_clib

PUBLIC sprite_set_y


; void sprite_set_y(struct sprite *spr, uint16_t y);
sprite_set_y:
    pop     af
    pop     bc
    pop     hl
    push    hl
    push    bc
    push    af
    INCLUDE "target/zxn/sprites/z80/asm_sprite_set_y.asm"

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sprite_set_y
defc   _sprite_set_y = sprite_set_y
ENDIF
