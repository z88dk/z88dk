
SECTION code_clib

PUBLIC sprite_set_x


; void sprite_set_x(struct sprite *spr, uint16_t x);
sprite_set_x:
    pop     af
    pop     bc
    pop     hl
    push    hl
    push    bc
    push    af
    INCLUDE "target/zxn/sprites/z80/asm_sprite_set_x.asm"

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sprite_set_x
defc   _sprite_set_x = sprite_set_x
ENDIF
