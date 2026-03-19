
SECTION code_clib

PUBLIC sprite_update


; void sprite_update(uint8_t spnum, struct sprite *spr);
sprite_update:
    pop     af
    pop     hl
    pop     bc
    push    bc
    push    hl
    push    af
    INCLUDE "target/zxn/sprites/z80/asm_sprite_update.asm"

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sprite_update
defc   _sprite_update = sprite_update
ENDIF
