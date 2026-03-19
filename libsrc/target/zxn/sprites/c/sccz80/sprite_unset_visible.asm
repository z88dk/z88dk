
SECTION code_clib

PUBLIC sprite_unset_visible


; void sprite_unset_visible(struct sprite *spr);
sprite_unset_visible:
    pop     af
    pop     hl
    push    hl
    push    af
    INCLUDE "target/zxn/sprites/z80/asm_sprite_unset_visible.asm"

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sprite_unset_visible
defc   _sprite_unset_visible = sprite_unset_visible
ENDIF
