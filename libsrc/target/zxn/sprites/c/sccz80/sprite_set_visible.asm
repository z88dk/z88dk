
SECTION code_clib

PUBLIC sprite_set_visible


; void sprite_set_visible(struct sprite *spr);
sprite_set_visible:
    pop     af
    pop     hl
    push    hl
    push    af
    INCLUDE "target/zxn/sprites/z80/asm_sprite_set_visible.asm"

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sprite_set_visible
defc   _sprite_set_visible = sprite_set_visible
ENDIF
