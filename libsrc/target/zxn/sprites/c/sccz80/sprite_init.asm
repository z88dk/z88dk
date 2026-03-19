
SECTION code_clib

PUBLIC sprite_init


; void sprite_init(struct sprite *spr);
sprite_init:
    pop     af
    pop     hl
    push    hl
    push    af
    INCLUDE "target/zxn/sprites/z80/asm_sprite_init.asm"

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sprite_init
defc   _sprite_init = sprite_init
ENDIF
