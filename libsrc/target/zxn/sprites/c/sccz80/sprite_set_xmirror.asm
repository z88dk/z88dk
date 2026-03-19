
SECTION code_clib

PUBLIC sprite_set_xmirror


; void sprite_set_xmirror(struct sprite *spr);
sprite_set_xmirror:
    pop     af
    pop     hl
    push    hl
    push    af
    INCLUDE "target/zxn/sprites/z80/asm_sprite_set_xmirror.asm"

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sprite_set_xmirror
defc   _sprite_set_xmirror = sprite_set_xmirror
ENDIF
