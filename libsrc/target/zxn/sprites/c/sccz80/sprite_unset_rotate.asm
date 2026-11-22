
SECTION code_clib

PUBLIC sprite_unset_rotate


; void sprite_unset_rotate(struct sprite *spr);
sprite_unset_rotate:
    pop     af
    pop     hl
    push    hl
    push    af
    INCLUDE "target/zxn/sprites/z80/asm_sprite_unset_rotate.asm"

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sprite_unset_rotate
defc   _sprite_unset_rotate = sprite_unset_rotate
ENDIF
